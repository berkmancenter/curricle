# frozen_string_literal: true

FactoryBot.define do
  factory :course_instructor do
    course
    sequence(:email) { |n| "instructor#{n}@example.edu" }
    first_name { 'Course' }
    instructor_role { 'HEAD' }
    sequence(:last_name) { |n| "Instructor #{n}" }
  end
end
