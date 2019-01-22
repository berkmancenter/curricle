# frozen_string_literal: true

RSpec.describe Types::UserCourseType do
  it { is_expected.to have_field(:course).of_type('Course!') }
  it { is_expected.to have_field(:created_at).of_type('String!') }
  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:include_in_path).of_type('Boolean!') }
  it { is_expected.to have_field(:updated_at).of_type('String!') }
end
