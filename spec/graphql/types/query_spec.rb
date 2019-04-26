# frozen_string_literal: true

module Types
  RSpec.describe Query do
    subject { described_class }

    it { is_expected.to have_field(:course).of_type('Course') }
    it { is_expected.to have_field(:course_counts).of_type('[CourseCount!]!') }
    it { is_expected.to have_field(:courses_connected_by_instructor).of_type('[Course!]!') }
    it { is_expected.to have_field(:courses_connection).of_type('CoursesConnection!') }
    it { is_expected.to have_field(:instructor_names).of_type('[String!]!') }
    it { is_expected.to have_field(:user_courses).of_type('[Course!]!') }
  end
end