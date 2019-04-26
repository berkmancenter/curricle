# frozen_string_literal: true

module Types
  RSpec.describe CourseMeetingPatternType do
    subject { described_class }

    it { is_expected.to have_field(:class_meeting_number).of_type('String') }
    it { is_expected.to have_field(:class_section).of_type('String') }
    it { is_expected.to have_field(:course).of_type('Course') }
    it { is_expected.to have_field(:created_at).of_type('String!') }
    it { is_expected.to have_field(:end_date).of_type('String') }
    it { is_expected.to have_field(:external_course_id).of_type('Int') }
    it { is_expected.to have_field(:external_facility_id).of_type('String') }
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:meeting_time_end).of_type('String') }
    it { is_expected.to have_field(:meeting_time_end_tod).of_type('String') }
    it { is_expected.to have_field(:meeting_time_start).of_type('String') }
    it { is_expected.to have_field(:meeting_time_start_tod).of_type('String') }
    it { is_expected.to have_field(:meets_on_friday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_monday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_saturday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_sunday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_thursday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_tuesday).of_type('Boolean') }
    it { is_expected.to have_field(:meets_on_wednesday).of_type('Boolean') }
    it { is_expected.to have_field(:start_date).of_type('String') }
    it { is_expected.to have_field(:term_name).of_type('String') }
    it { is_expected.to have_field(:term_year).of_type('Int') }
    it { is_expected.to have_field(:updated_at).of_type('String!') }
  end
end
