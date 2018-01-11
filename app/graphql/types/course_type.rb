# frozen_string_literal: true

Types::CourseType = GraphQL::ObjectType.define do
  name 'Course'
  description 'Represents a course in Curricle'

  field :academic_group, !types.String, 'Academic group'
  field :catalog_number, !types.Int, 'Catalog number'
  field :component, types.String, 'Component'
  field :course_description_long, types.String, 'Extended description'
  field :id, !types.ID, 'Unique ID'
  field :course_instructors, types[Types::CourseInstructorType], 'List of course instructors' do
    resolve(
      lambda do |course, _args, _ctx|
        BatchLoader.for(course.id).batch(default_value: []) do |course_ids, loader|
          CourseInstructor.where(course_id: course_ids).each do |course_instructor|
            loader.call(course_instructor.course_id) { |memo| memo << course_instructor }
          end
        end
      end
    )
  end
  field :subject, !types.String, 'Subject'
  field :term_name, !types.String, 'Term name'
  field :term_year, !types.Int, 'Term year'
  field :title, !types.String, 'Title'
  field :units_maximum, types.Int, 'Maximum units'
end
