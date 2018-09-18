# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  it 'has a valid factory' do
    expect(course).to be_valid
  end
end
