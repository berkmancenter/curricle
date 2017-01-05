class Course < ApplicationRecord
  include PgSearch

  has_many :course_meeting_patterns
  has_many :course_instructors

  pg_search_scope :search_for, lambda { |query_filters|
    query = {
      query: query_filters[:keywords],
      against: [],
      associated_against: {},
      using: {
        tsearch: {
          dictionary: "english"
        }
      }
    }

    # build against/associated_against options based on selected keyword options
    query_filters[:keyword_options].map { |field|
      if map = Course.keyword_options_map[field.to_sym]
        if db_field = map[:db_field]
          if db_field[:table] == :courses
            Array(db_field[:columns]).each do |col|
              query[:against] << col
            end
          else
            query[:associated_against][db_field[:table]] = db_field[:columns]
          end
        end
      end
    }

    query[:against] = %w(title course_description_long) if query[:against].empty? && query[:associated_against].empty?

    query
  }

  def self.for_day(day, query_params = {})
    query_params[:id] = CourseMeetingPattern.select(:course_id).where("meets_on_#{day}": true)
    Course.where(query_params).distinct
  end

  def self.subjects(query = nil)
    # TODO: figure out if we can replace uniq with distinct
    query.pluck(:subject_academic_org_description).uniq
  end

  def self.schools
    order(:academic_group).distinct.pluck(:academic_group)
  end

  def self.departments
    order(:class_academic_org_description).distinct.pluck(:class_academic_org_description)
  end

  def self.subject_descriptions
    order(:subject_description).distinct.pluck(:subject_description)
  end

  def self.terms
    select('DISTINCT on (term_name,term_year) term_name, term_year').where("term_year >= ?", Date.today.year).order(term_year: :asc, term_name: :desc).map { |term|
      "#{term.term_name}_#{term.term_year}"
    }
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

  # Users can select from a set of keyword options to query against. This is a map of those
  # options, their metadata, and their related fields in the database
  def self.keyword_options_map
    {
      title: {
        display: 'Title',
        default: true,
        db_field: {
          table: :courses,
          columns: [:title]
        }
      },
      description: {
        display: 'Description',
        default: true,
        db_field: {
          table: :courses,
          columns: [:course_description_long]
        }
      },
      instructor: {
        display: 'Instructor',
        default: false,
        db_field: {
          table: :course_instructors,
          columns: [:first_name, :last_name]
        }
      },
      library: {
        display: 'Library reserves',
        default: false
      }
    }
  end

  # Used to setup and optionally populate the schedule mapping used in the schedule filter
  def self.schedule_filter_map(values = {})
    {
      monday: {
        min: values["monday_min"],
        max: values["monday_max"]
      },
      tuesday: {
        min: values["tuesday_min"],
        max: values["tuesday_max"]
      },
      wednesday: {
        min: values["wednesday_min"],
        max: values["wednesday_max"]
      },
      thursday: {
        min: values["thursday_min"],
        max: values["thursday_max"]
      },
      friday: {
        min: values["friday_min"],
        max: values["friday_max"]
      }
    }
  end
end
