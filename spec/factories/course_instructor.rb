# frozen_string_literal: true

FactoryBot.define do
  factory :course_instructor do
    course

    first_name { 'Course' }
    instructor_role { 'HEAD' }
    last_name { 'Instructor' }

    sequence(:email) { |n| "instructor#{n}@example.edu" }
  end
end
