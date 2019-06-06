# frozen_string_literal: true

module Resolvers
  # Return a collection of objects with aggregate data about course counts
  class CourseCounts < Resolvers::Base
    type [Types::CourseCountType], null: false

    argument :basic, String, 'Simple search queries using the my.harvard operators', required: false
    argument :component, Types::Enums::Component, required: false
    argument :department, Types::Enums::Department, required: false
    argument :filtered, Boolean, required: false
    argument :semester, Types::Inputs::Semester, required: false
    argument :semester_range, Types::Inputs::SemesterRange, required: false

    def resolve(**args)
      search = perform_search(args)

      count_courses(search)
    end

    private

    def perform_search(args)
      component_field = args[:filtered] ? :component_filtered : :component

      Course.search do
        with(component_field, args[:component]) if args[:component]
        with(:subject_academic_org_description, args[:department]) if args[:department]

        filter_by_single_semester(self, args[:semester]) if args[:semester]
        filter_by_semester_range(self, args[:semester_range]) if args[:semester_range]
        basic_search(self, args[:basic]) if args[:basic]

        json_facet(:subject_academic_org_description, limit: -1, nested: { field: component_field })
      end
    end

    def basic_search(sunspot, query)
      stripped_query = query.gsub(/[()]/, '"')
      phrases = stripped_query.split('|')

      sunspot.instance_eval do
        any do
          phrases.each do |phrase|
            fulltext phrase, fields: %i[class_academic_org_description course_description_long title]
          end
        end
      end
    end

    def filter_by_single_semester(sunspot, semester)
      sunspot.instance_eval do
        with(:term_name, semester[:term_name])
        with(:term_year, semester[:term_year])
      end
    end

    def filter_by_semester_range(sunspot, semester_range)
      return filter_by_single_semester(sunspot, semester_range.start) if semester_range.end.blank?

      sunspot.instance_eval do
        any_of do
          # add semesters for start year
          all_of do
            with(:term_name, start_year_term_scope(semester_range.start.term_name))
            with(:term_year, semester_range.start.term_year)
          end

          # add semesters for end year
          all_of do
            with(:term_name, end_year_term_scope(semester_range.end.term_name))
            with(:term_year, semester_range.end.term_year)
          end

          # add all semesters for intermediate years
          intermediate_years = (semester_range.start.term_year..semester_range.end.term_year).to_a[1...-1]

          return unless intermediate_years.any?

          all_of do
            with :term_name, Types::Enums::TermName.values.values.map(&:value)
            with :term_year, intermediate_years
          end
        end
      end
    end

    def count_courses(search)
      search.facet(:subject_academic_org_description).rows.each_with_object([]) do |row, arr|
        row.nested.each do |nested_row|
          arr << OpenStruct.new(
            component: nested_row.value,
            department: row.value,
            count: nested_row.count
          )
        end
      end
    end

    def start_year_term_scope(term_name)
      case term_name
      when 'Spring'
        %w[Spring Summer Fall]
      when 'Summer'
        %w[Summer Fall]
      when 'Fall'
        %w[Fall]
      end
    end

    def end_year_term_scope(term_name)
      case term_name
      when 'Spring'
        %w[Spring]
      when 'Summer'
        %w[Spring Summer]
      when 'Fall'
        %w[Spring Summer Fall]
      end
    end
  end
end
