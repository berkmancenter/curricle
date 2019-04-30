# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    sequence(:external_course_id)
    offer_number { 1 }
    term_code { 2168 }
    session_code { 1 }
    class_section { 1 }
    title { 'Course Title' }
  end
end
