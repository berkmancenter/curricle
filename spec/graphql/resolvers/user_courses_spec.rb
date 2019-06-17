require 'rails_helper'

module Resolvers
  RSpec.describe UserCourses do
    let(:outcome) { described_class.run(inputs) }
    let(:user) { create(:user) }
    let!(:user_courses) { create_pair(:user_course, user: user) }

    context 'with a user' do
      let(:inputs) { { current_user: user } }

      it 'returns the expected list of courses' do
        expect(outcome).to match_array(user_courses)
      end
    end

    context 'with a schedule token' do
      let(:inputs) { { current_user: nil, schedule_token: user.schedule_token } }

      it 'returns the expected list of courses' do
        expect(outcome).to match_array(user_courses)
      end
    end

    context 'with no user or schedule token' do
      let(:inputs) { { current_user: nil } }

      it 'returns an empty collection' do
        expect(outcome).to be_empty
      end
    end
  end
end
