# frozen_string_literal: true

module Types
  class CourseAttributeType < Types::BaseObject
    description 'Extended attributes for Courses'

    field :academic_career, String, null: true
    field :bracketed_flag, String, null: true
    field :class_section, String, null: false
    field :course, Types::CourseType, null: false
    field :course_offer_number, Integer, null: true
    field :created_at, String, null: false
    field :crse_attr_value, String, null: true
    field :crse_attr_value_description, String, null: true
    field :crse_attribute, String, null: true
    field :crse_attribute_description, String, null: true
    field :external_course_id, Integer, null: false
    field :id, ID, null: false
    field :session_code, String, null: false
    field :term_code, Integer, null: false
    field :term_description, String, null: false
    field :updated_at, String, null: false
  end
end
