require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to have_many(:annotations) }
  it { is_expected.to have_many(:tags) }
  it { is_expected.to have_many(:user_courses) }
  it { is_expected.to have_many(:courses).through(:user_courses) }

  describe 'factory' do
    it 'is valid' do
      expect(user).to be_valid
    end

    it 'generates an api token' do
      expect(user.api_token).not_to be_nil
    end

    it 'generates a schedule token' do
      expect(user.schedule_token).not_to be_nil
    end
  end
end
