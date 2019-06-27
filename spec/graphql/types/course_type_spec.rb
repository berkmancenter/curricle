# frozen_string_literal: true

module Types
  RSpec.describe CourseType do
    subject { described_class }

    it { is_expected.to have_field(:academic_group).of_type('String') }
    it { is_expected.to have_field(:academic_group_description).of_type('String') }
    it { is_expected.to have_field(:course_attributes).of_type('[CourseAttribute]') }
    # it { is_expected.to have_field(:created_at).of_type('String!') }
    # it { is_expected.to have_field(:display_name).of_type('String') }
    # it { is_expected.to have_field(:email).of_type('String') }
    # it { is_expected.to have_field(:first_name).of_type('String') }
    # it { is_expected.to have_field(:id).of_type('ID!') }
    # it { is_expected.to have_field(:instructor_role).of_type('String') }
    # it { is_expected.to have_field(:last_name).of_type('String') }
    # it { is_expected.to have_field(:middle_name).of_type('String') }
    # it { is_expected.to have_field(:name_prefix).of_type('String') }
    # it { is_expected.to have_field(:name_suffix).of_type('String') }
    # it { is_expected.to have_field(:updated_at).of_type('String!') }
  end
end
