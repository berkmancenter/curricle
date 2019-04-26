# frozen_string_literal: true

module Types
  RSpec.describe FacetType do
    subject { described_class }

    it { is_expected.to have_field(:count).of_type('Int') }
    it { is_expected.to have_field(:value).of_type('String') }
  end
end
