# frozen_string_literal: true

SortByEnum = GraphQL::EnumType.define do
  name 'SortByEnum'

  value('COURSE_ID', 'Course ID', value: %i[subject catalog_number])
  value('DEPARTMENT', 'Department', value: %i[subject])
  value('RELEVANCE', 'Relevance', value: %i[score academic_year term_name])
  value('SCHOOL', 'School', value: %i[academic_group])
  value('SEMESTER', 'Semester', value: %i[academic_year term_name])
  value('TITLE', 'Title', value: %i[title_sortable])
end

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
    argument :sort_by, SortByEnum, 'Sort method for search results'

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
