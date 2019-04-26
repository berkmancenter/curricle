require 'rails_helper'

RSpec.describe UserCourse, type: :model do
  let(:user_course) { create(:user_course) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:course) }

  it 'has a valid factory' do
    expect(user_course).to be_valid
  end
end
