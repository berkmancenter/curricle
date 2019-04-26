# frozen_string_literal: true

module Types
  RSpec.describe Mutation do
    subject { described_class }

    it { is_expected.to have_field(:annotation_set) }
    it { is_expected.to have_field(:tag_remove) }
    it { is_expected.to have_field(:tag_set) }
    it { is_expected.to have_field(:user_course_remove) }
    it { is_expected.to have_field(:user_course_set) }
  end
end
