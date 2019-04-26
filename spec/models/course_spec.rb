# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { create(:course) }

  it { is_expected.to have_many(:annotations) }
  it { is_expected.to have_many(:course_instructors) }
  it { is_expected.to have_many(:course_meeting_patterns) }
  it { is_expected.to have_many(:course_readings) }
  it { is_expected.to have_many(:tags) }
  it { is_expected.to have_many(:user_courses) }
  it { is_expected.to have_many(:users).through(:user_courses) }

  it 'has a valid factory' do
    expect(course).to be_valid
  end
end
