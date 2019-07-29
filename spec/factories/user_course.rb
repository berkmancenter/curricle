FactoryBot.define do
  factory :user_course do
    course
    user
    imported { false }
  end
end
