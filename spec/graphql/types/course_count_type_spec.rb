# frozen_string_literal: true

module Types
  RSpec.describe CourseCountType do
    subject { described_class }

    it { is_expected.to have_field(:component).of_type('String!') }
    it { is_expected.to have_field(:count).of_type('Int!') }
    it { is_expected.to have_field(:department).of_type('String!') }
  end
end
