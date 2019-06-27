# frozen_string_literal: true

module Types
  RSpec.describe CourseAttributeType do
    subject { described_class }

    it { is_expected.to have_field(:academic_career).of_type('String') }
    it { is_expected.to have_field(:bracketed_flag).of_type('String') }
    it { is_expected.to have_field(:class_section).of_type('String!') }
    it { is_expected.to have_field(:course).of_type('Course!') }
    it { is_expected.to have_field(:course_offer_number).of_type('Int') }
    it { is_expected.to have_field(:created_at).of_type('String!') }
    it { is_expected.to have_field(:crse_attr_value).of_type('String') }
    it { is_expected.to have_field(:crse_attr_value_description).of_type('String') }
    it { is_expected.to have_field(:crse_attribute).of_type('String') }
    it { is_expected.to have_field(:crse_attribute_description).of_type('String') }
    it { is_expected.to have_field(:external_course_id).of_type('Int!') }
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:session_code).of_type('String!') }
    it { is_expected.to have_field(:term_code).of_type('Int!') }
    it { is_expected.to have_field(:term_description).of_type('String!') }
    it { is_expected.to have_field(:updated_at).of_type('String!') }
  end
end
