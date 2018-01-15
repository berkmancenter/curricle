# frozen_string_literal: true

Types::CoursesByDepartmentType = GraphQL::ObjectType.define do
  name 'CoursesByDepartmentType'
  description 'Aggregate data for courses within a department'

  field :course_count, !types.Int, 'Number of courses'
  field :department, !types.String, 'Department'
  field :year, !types.String, 'Year'
end
