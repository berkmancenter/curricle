# frozen_string_literal: true

module Types
  class CourseCountType < Types::BaseObject
    description 'Aggregate data about the number of courses'

    field :component, String, null: false
    field :count, Integer, null: false
    field :department, String, null: false
  end
end
