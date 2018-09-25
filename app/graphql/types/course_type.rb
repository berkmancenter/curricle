# frozen_string_literal: true

Types::CourseType = GraphQL::ObjectType.define do
  name 'Course'
  description 'Represents a course in Curricle'

  field :academic_group, types.String, 'Academic group'
  field :academic_group_description, types.String, 'Academic group description'
  field :academic_year, types.Int, 'Academic year'

  field :annotation, Types::AnnotationType, 'Annotation added by the current user' do
    resolve(
      lambda do |course, _args, context|
        BatchLoader.for(course.id).batch do |course_ids, loader|
          Annotation.where(course: course_ids, user: context[:current_user]).each do |annotation|
            loader.call(annotation.course_id, annotation)
          end
        end
      end
    )
  end

  field :catalog_number, types.String, 'Catalog number'
  field :class_academic_org_description, types.String, 'Class academic organization description'
  field :class_section, types.String, 'Class section'
  field :component, types.String, 'Component'
  field :course_description, types.String, 'Course description'
  field :course_description_long, types.String, 'Extended course description'

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

  field :course_meeting_patterns, types[Types::CourseMeetingPatternType], 'List of course meeting patterns' do
    resolve(
      lambda do |course, _args, _ctx|
        BatchLoader.for(course.id).batch(default_value: []) do |course_ids, loader|
          CourseMeetingPattern.where(course_id: course_ids).each do |course_meeting_pattern|
            loader.call(course_meeting_pattern.course_id) { |memo| memo << course_meeting_pattern }
          end
        end
      end
    )
  end

  field :course_note, types.String, 'Course note'
  field :created_at, !types.String, 'Created at'
  field :division, types.String, 'Division'
  field :division_description, types.String, 'Division description'
  field :external_course_id, types.Int, 'External course ID'
  field :grading_basis_description, types.String, 'Grading basis description'
  field :id, !types.ID, 'Unique ID'
  field :prereq, types.Int, 'Prerequisite'
  field :subject, types.String, 'Subject'
  field :subject_academic_org_description, types.String, 'Subject academic organization description'
  field :subject_description, types.String, 'Subject description'

  field :tags, types[Types::TagType], 'List of tags added by the current user' do
    resolve(
      lambda do |course, _args, context|
        BatchLoader.for(course.id).batch(default_value: []) do |course_ids, loader|
          Tag.where(course: course_ids, user: context[:current_user]).each do |tag|
            loader.call(tag.course_id) { |memo| memo << tag }
          end
        end
      end
    )
  end

  field :term_name, types.String, 'Term name'
  field :term_pattern_code, types.String, 'Term pattern code'
  field :term_pattern_description, types.String, 'Term pattern description'
  field :term_year, types.Int, 'Term year'
  field :title, types.String, 'Title'
  field :units_maximum, types.Int, 'Maximum units'
  field :updated_at, !types.String, 'Updated at'

  field :user_course, Types::UserCourseType, "Metadata about the user's course selection" do
    resolve(
      lambda do |course, _args, context|
        BatchLoader.for(course.id).batch do |course_ids, loader|
          UserCourse.where(course: course_ids, user: context[:current_user]).each do |user_course|
            loader.call(user_course.course_id, user_course)
          end
        end
      end
    )
  end
end
