# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    description 'Represents a course in Curricle'

    def annotation
      BatchLoader::GraphQL.for(object.id).batch do |course_ids, loader|
        Annotation.where(course: course_ids, user: context[:current_user]).each do |annotation|
          loader.call(annotation.course_id, annotation)
        end
      end
    end

    def course_description_long
      Sanitize.fragment(
        object.course_description_long,
        elements: %w[
          b
          em
          i
          p
          strong
        ]
      )
    end

    def course_instructors
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |course_ids, loader|
        CourseInstructor.where(course_id: course_ids).each do |course_instructor|
          loader.call(course_instructor.course_id) { |memo| memo << course_instructor }
        end
      end
    end

    def course_meeting_patterns
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |course_ids, loader|
        CourseMeetingPattern.where(course_id: course_ids).each do |course_meeting_pattern|
          loader.call(course_meeting_pattern.course_id) { |memo| memo << course_meeting_pattern }
        end
      end
    end

    def semester
      "#{object.term_name} #{object.term_year}"
    end

    def tags
      BatchLoader::GraphQL.for(object.id).batch(default_value: []) do |course_ids, loader|
        Tag.where(course: course_ids, user: context[:current_user]).each do |tag|
          loader.call(tag.course_id) { |memo| memo << tag }
        end
      end
    end

    def user_course
      BatchLoader::GraphQL.for(object.id).batch do |course_ids, loader|
        UserCourse.where(course: course_ids, user: context[:current_user]).each do |user_course|
          loader.call(user_course.course_id, user_course)
        end
      end
    end

    field :academic_group, String, null: true
    field :academic_group_description, String, null: true
    field :academic_year, Integer, null: true
    field :annotation, Types::AnnotationType, 'Annotation added by the current user', null: true
    field :catalog_number, String, null: true
    field :class_academic_org_description, String, null: true
    field :class_section, String, null: true
    field :component, String, null: true
    field :component_filtered, String, 'Simplified component field with similar components combined for less granularity', null: true
    field :course_description, String, null: true
    field :course_description_long, String, 'Extended course description', null: true
    field :course_instructors, [Types::CourseInstructorType, null: true], 'List of course instructors', null: true
    field :course_meeting_patterns, [Types::CourseMeetingPatternType, null: true], 'List of course meeting patterns', null: true
    field :course_note, String, null: true
    field :created_at, String, null: false
    field :division, String, null: true
    field :division_description, String, null: true
    field :external_course_id, Integer, null: true
    field :grading_basis_description, String, null: true
    field :id, ID, null: false
    field :prereq, Integer, 'Prerequisite', null: true
    field :semester, String, null: true
    field :subject, String, null: true
    field :subject_academic_org_description, String, null: true
    field :subject_description, String, null: true
    field :tags, [Types::TagType, null: true], 'List of tags added by the current user', null: true
    field :term_code, Integer, null: false
    field :term_name, String, null: true
    field :term_pattern_code, String, null: true
    field :term_pattern_description, String, null: true
    field :term_year, Integer, null: true
    field :title, String, null: true
    field :units_maximum, Integer, null: true
    field :updated_at, String, null: false
    field :user_course, Types::UserCourseType, "Metadata about the user's course selection", null: true
  end
end
