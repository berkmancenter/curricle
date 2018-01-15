# frozen_string_literal: true

module Resolvers
  # Return a collection of objects with the number of courses per department
  class CoursesByDepartmentResolver
    def call(_obj, args, _ctx)
      Course
        .where(academic_group: args[:academic_group])
        .group(:subject_academic_org_description)
        .group(:term_year)
        .count
        .map do |fields, course_count|
          OpenStruct.new(department: fields[0], year: fields[1], course_count: course_count)
        end
    end
  end
end
