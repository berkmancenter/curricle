# frozen_string_literal: true

module Resolvers
  # Return a collection of objects with aggregate data about course counts
  class CourseCountsResolver
    def call(_obj, args, _ctx)
      query = base_query
      query = filter_by_args(query, args)

      count_courses(query)
    end

    private

    def base_query
      Course
        .where.not(component: nil)
        .group(%i[component subject_academic_org_description])
    end

    def filter_by_args(query, args)
      query = query.where(component: args[:component]) if args[:component].present?
      query = query.where(subject_academic_org_description: args[:department]) if args[:department].present?

      query
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
  end
end
