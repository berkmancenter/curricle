# frozen_string_literal: true

RSpec.describe Types::FacetType do
  it { is_expected.to have_field(:count).of_type('Int') }
  it { is_expected.to have_field(:value).of_type('String') }
end
