# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseInstructor, type: :model do
  let(:course_instructor) { build(:course_instructor) }

  it 'has a valid factory' do
    expect(course_instructor).to be_valid
  end

  it { is_expected.to belong_to :course }
end
