# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :course_meeting_patterns
  has_many :course_instructors
  has_many :course_readings

  searchable do
    integer :id
    text :title
    string :term_name
    integer :term_year
    text :course_description_long
  end

  scope :return_as_relation, ->(search_results) do
    matching_item_ids = search_results.hits.map(&:primary_key)
    where id: matching_item_ids
  end

  before_save :set_division

  def for_day(day, query_params = {})
    query_params[:id] = CourseMeetingPattern.select(:course_id).where('meets_on_#{day}': true)
    Course.where(query_params).distinct
  end

  def groups(query = nil)
    query.pluck(:division_description).uniq
  end

  def schools
    where.not(academic_group: [nil, '']).order(:academic_group).distinct.pluck(:academic_group)
  end

  def self.departments
    where.not(class_academic_org_description: [nil, '']).order(:class_academic_org_description).distinct.pluck(:class_academic_org_description)
  end

  def self.semesters
    where.not(term_year: [nil]).order(:term_name).distinct.pluck(:term_name)
  end

  def subject_descriptions
    where.not(subject_description: [nil, '']).order(:subject_description).distinct.pluck(:subject_description)
  end

  def component_types
    where.not(component: [nil, '']).order(:component).distinct.pluck(:component)
  end

  def terms
    select('DISTINCT on (term_name,term_year) term_name, term_year').where('term_year >= ?', Time.zone.today.year).order(term_year: :asc, term_name: :desc).map { |term|
      "#{term.term_name}_#{term.term_year}"
    }
  end

  def set_division
    mapping = DivisionMapping.find_by(
      academic_group: academic_group,
      subject_description: subject_description
    )

    # if we didn't find a mapping, search for one without an academic_group
    if mapping.blank?
      mapping = DivisionMapping.find_by(
        academic_group: nil,
        subject_description: subject_description
      )
    end

    if mapping.blank?
      self.division = 'misc'
      self.division_description = 'Misc'
    else
      self.division = mapping.division
      self.division_description = mapping.division_description
    end
  end

  def set_division!
    set_division
    save
  end

  def meeting
    course_meeting_patterns.find_by(
      term_name: term_name,
      term_year: term_year,
      class_section: class_section
    )
  end

  def instructor
    course_instructors.find_by(
      term_name: term_name,
      term_year: term_year,
      class_section: class_section
    )
  end

  def subject_and_catalog
    "#{subject} #{catalog_number}"
  end

  # Users can select from a set of keyword options to query against. This is a map of those
  # options, their metadata, and their related fields in the database
  def self.keyword_options_map
    {
      title: {
        display: 'Title',
        default: true,
        db_field: {
          table: :courses,
          columns: %i[title]
        }
      },
      description: {
        display: 'Description',
        default: true,
        db_field: {
          table: :courses,
          columns: %i[course_description_long]
        }
      },
      instructor: {
        display: 'Instructor',
        default: false,
        db_field: {
          table: :course_instructors,
          columns: %i[first_name last_name]
        }
      },
      library: {
        display: 'Course Readings',
        default: false,
        db_field: {
          table: :course_readings,
          columns: %i[reading_title author_last_name author_first_name]
        }
      }
    }
  end

  # Used to setup and optionally populate the schedule mapping used in the schedule filter
  def self.schedule_filter_map(values = {})
    {
      monday: {
        min: values['monday_min'],
        max: values['monday_max']
      },
      tuesday: {
        min: values['tuesday_min'],
        max: values['tuesday_max']
      },
      wednesday: {
        min: values['wednesday_min'],
        max: values['wednesday_max']
      },
      thursday: {
        min: values['thursday_min'],
        max: values['thursday_max']
      },
      friday: {
        min: values['friday_min'],
        max: values['friday_max']
      }
    }
  end
end
