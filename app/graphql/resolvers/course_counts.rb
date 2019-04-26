# frozen_string_literal: true

module Resolvers
  # Return a collection of objects with aggregate data about course counts
  class CourseCounts < Resolvers::Base
    type [Types::CourseCountType], null: false

    argument :component, Types::Enums::Component, required: false
    argument :department, Types::Enums::Department, required: false
    argument :semester, Types::Inputs::Semester, required: false
    argument :semester_range, Types::Inputs::SemesterRange, required: false

    def resolve(**args)
      query = base_query

      query = filter_by_args(query, args)
      query = filter_by_semester(query, args)
      query = filter_by_semester_range(query, args[:semester_range])

      count_courses(query)
    end

    private

    def base_query
      Course
        .where.not(component: nil)
        .where.not(component: '')
        .group(%i[component subject_academic_org_description])
        .order(:subject_academic_org_description, :component)
    end

    def filter_by_args(query, args)
      query = query.where(component: args[:component]) if args[:component].present?
      query = query.where(subject_academic_org_description: args[:department]) if args[:department].present?

      query
    end

    def filter_by_semester(query, args)
      return query if args[:semester].blank?

      term_name = args[:semester][:term_name]
      term_year = args[:semester][:term_year]

      query.where(term_name: term_name, term_year: term_year)
    end

    def filter_by_semester_range(query, semester_range)
      return query if semester_range.blank?
      return query.where(term_name: semester_range.start.term_name, term_year: semester_range.start.term_year) if semester_range.end.blank?

      # add semesters for start year
      semester_query = query.where(
        term_name: start_year_term_scope(semester_range.start.term_name),
        term_year: semester_range.start.term_year
      )

      # add semesters for end year
      semester_query = semester_query.or(
        query.where(
          term_name: end_year_term_scope(semester_range.end.term_name),
          term_year: semester_range.end.term_year
        )
      )

      # add all semesters for intermediate years
      intermediate_years = (semester_range.start.term_year..semester_range.end.term_year).to_a[1...-1]

      if intermediate_years.any?
        semester_query = semester_query.or(
          query.where(
            term_year: intermediate_years
          )
        )
      end

      semester_query
    end

    def count_courses(query)
      query
        .count
        .map do |(component, department), count|
          OpenStruct.new(
            component: component,
            department: department,
            count: count
          )
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
