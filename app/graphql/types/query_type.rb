# frozen_string_literal: true

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'Curricle queries'

  field :courses, !types[Types::CourseType] do
    description 'Queries that return lists of courses'

    argument :semester_range, Inputs::SemesterRangeInput, 'Range of semesters to search'
    argument :deluxe_keywords, types[!Inputs::DeluxeKeywordInput], 'List of objects for a weighted, field-specific search'
    argument :ids, types[!types.ID], 'List of course IDs'
    argument :per_page, types.Int, 'Number of courses to return'
    argument :page, types.Int, 'Pagination page'

    resolve Resolvers::CoursesResolver.new
  end

  field :count_courses_by_department, !types[Types::CoursesByDepartmentType] do
    description 'Return counts of courses by department'

    argument :academic_group, !types.String, 'Academic group'

    resolve Resolvers::CoursesByDepartmentResolver.new
  end

  field :course, Types::CourseType do
    description 'Find a course'

    argument :id, !types.ID, 'Course ID'

    resolve ->(_obj, args, _ctx) { Course.find(args[:id]) }
  end
end
