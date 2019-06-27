require 'rails_helper'

RSpec.describe CourseAttribute, type: :model do
  let(:course_attribute) { create(:course_attribute) }

  it { is_expected.to belong_to(:course) }
  it { is_expected.to validate_presence_of(:class_section) }
  it { is_expected.to validate_presence_of(:course_id) }
  it { is_expected.to validate_presence_of(:external_course_id) }
  it { is_expected.to validate_presence_of(:session_code) }
  it { is_expected.to validate_presence_of(:term_code) }

  it 'has a valid factory' do
    expect(course_attribute).to be_valid
  end
end
