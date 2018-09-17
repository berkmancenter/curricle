# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:annotations) }
  it { is_expected.to have_many(:tags) }
  it { is_expected.to have_many(:user_courses) }
  it { is_expected.to have_many(:courses).through(:user_courses) }
end
