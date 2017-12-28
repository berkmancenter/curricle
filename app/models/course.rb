# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :course_meeting_patterns
  has_many :course_instructors
  has_many :course_readings

  searchable do
    integer :id
    integer :external_course_id
    text :title
    string :term_name
    integer :term_year
    integer :academic_year
    string :class_section
    string :component
    integer :prereq
    string :subject
    text :subject_description
    string :subject_description
    text :subject_academic_org_description
    text :academic_group
    string :academic_group
    text :academic_group_description
    text :grading_basis_description
    string :term_pattern_code
    text :term_pattern_description
    integer :units_maximum
    integer :catalog_number
    text :course_description
    text :course_description_long
    text :course_note
    text :class_academic_org_description
    string :class_academic_org_description
    join(:class_meeting_number, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:meeting_time_start, target: CourseMeetingPattern, type: :integer, join: { from: :course_id, to: :id })
    join(:meeting_time_end, target: CourseMeetingPattern, type: :integer, join: { from: :course_id, to: :id })
    join(:meets_on_monday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_tuesday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_wednesday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_thursday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_friday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_saturday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_sunday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:start_date, target: CourseMeetingPattern, type: :date, join: { from: :course_id, to: :id })
    join(:end_date, target: CourseMeetingPattern, type: :date, join: { from: :course_id, to: :id })
    join(:external_facility_id, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:facility_description, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:first_name, target: CourseInstructor, type: :text, join: { from: :course_id, to: :id })
    join(:last_name, target: CourseInstructor, type: :text, join: { from: :course_id, to: :id })
    join(:title, prefix: 'reading', target: CourseReading, type: :text, join: { from: :course_id, to: :id })
    join(:author_first_name, target: CourseReading, type: :text, join: { from: :course_id, to: :id })
    join(:author_last_name, target: CourseReading, type: :text, join: { from: :course_id, to: :id })
  end

  scope :return_as_relation, ->(search_results) do
    matching_item_ids = search_results.hits.map(&:primary_key)
    where id: matching_item_ids
  end

  before_save :set_division

  def for_day(_day, query_params = {})
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
    select('DISTINCT on (term_name,term_year) term_name, term_year').order(term_year: :asc, term_name: :desc).map do |term|
      "#{term.term_name} #{term.term_year}"
    end
  end

  def self.courses_by_day_and_term(day, term_name, term_year)
    Course.joins(:course_meeting_patterns).select('courses.id, courses.external_course_id as external_id, title').where("lower(courses.term_name) = ? and courses.term_year = ? and course_meeting_patterns.#{day} = ?", term_name.downcase, term_year, true).distinct
  end

  def subject_descriptions
    where.not(subject_description: [nil, '']).order(:subject_description).distinct.pluck(:subject_description)
  end

  def component_types
    where.not(component: [nil, '']).order(:component).distinct.pluck(:component)
  end

  def terms
    select('DISTINCT on (term_name,term_year) term_name, term_year').where('term_year >= ?', Time.zone.today.year).order(term_year: :asc, term_name: :desc).map do |term|
      "#{term.term_name}_#{term.term_year}"
    end
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
      term_year: term_year
      # TODO: courses doen't have data - class_section: class_section
    )
  end

  def instructor
    course_instructors.find_by(
      term_name: term_name,
      term_year: term_year
      # TODO: courses doen't have data - class_section: class_section
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
