# frozen_string_literal: true

module Resolvers
  # Return a collection of objects with aggregate data about course counts
  class CourseCounts

    START_YEAR_TERM_SCOPE = {
      'Spring' => %w[Spring Summer Fall],
      'Summer' => %w[Summer Fall],
      'Fall' => %w[Fall]
    }.freeze

    END_YEAR_TERM_SCOPE = {
      'Spring' => %w[Spring],
      'Summer' => %w[Spring Summer],
      'Fall' => %w[Spring Summer Fall]
    }.freeze

    def self.run(**args)
      component_field = args[:filtered] ? :component_filtered : :component

      search = perform_search(
        basic: args[:basic],
        component: args[:component],
        course_levels: args[:course_levels],
        department: args[:department],
        semester: args[:semester],
        semester_range: args[:semester_range],
        component_field: component_field
      )

      count_courses(search, component_field)
    end

    def self.perform_search(basic:, component:, course_levels:, department:, semester:, semester_range:, component_field:)
      Course.search do
        with component_field, component if component
        with :subject_academic_org_description, department if department
        with :crse_attr_value, course_levels if course_levels

        filter_by_single_semester(self, semester) if semester
        filter_by_semester_range(self, semester_range.start, semester_range.end) if semester_range
        basic_search(self, basic) if basic

        # TODO: identify a cleaner way of returning all results or revert to using JSON faceting when available
        paginate page: 1, per_page: 99_999
      end
    end

    def self.basic_search(sunspot, query)
      phrases = query.gsub(/[()]/, '"').split('|')

      sunspot.instance_eval do
        any do
          phrases.each { |phrase| fulltext phrase, fields: %i[class_academic_org_description course_description_long title] }
        end
      end
    end

    def self.filter_by_single_semester(sunspot, semester)
      sunspot.instance_eval do
        with(:term_name, semester[:term_name])
        with(:term_year, semester[:term_year])
      end
    end

    def self.filter_by_semester_range(sunspot, semester_range_start, semester_range_end)
      return filter_by_single_semester(sunspot, semester_range_start) if semester_range_end.blank?

      sunspot.instance_eval do
        any_of do
          # add semesters for start year
          all_of do
            with(:term_name, START_YEAR_TERM_SCOPE[semester_range_start.term_name])
            with(:term_year, semester_range_start.term_year)
          end

          # add semesters for end year
          all_of do
            with(:term_name, END_YEAR_TERM_SCOPE[semester_range_end.term_name])
            with(:term_year, semester_range_end.term_year)
          end

          # add all semesters for intermediate years
          intermediate_years = (semester_range_start.term_year..semester_range_end.term_year).to_a[1...-1]

          return unless intermediate_years.any?

          all_of do
            with :term_name, Types::Enums::TermName.values.values.map(&:value)
            with :term_year, intermediate_years
          end
        end
      end
    end

    def self.count_courses(search, component_field)
      course_ids = search.results.pluck(:id)

      data =
        Course
        .where(id: course_ids)
        .group([component_field, 'subject_academic_org_description'])
        .order(:subject_academic_org_description, component_field)

      data
        .count
        .map do |(component, department), count|
          OpenStruct.new(
            component: component,
            department: department,
            count: count
          )
        end
    end
  end
end
