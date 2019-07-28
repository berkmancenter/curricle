# frozen_string_literal: true

module Types
  module Enums
    RSpec.describe CourseLevel do
      let(:enum) { described_class }
      let(:values) { enum.values.keys }

      describe 'enum values' do
        it { expect(values).to match_array(%w[GRADCOURSE NOLEVEL PRIMGRAD PRIMUGRD UGRDGRAD]) }
      end
    end
  end
end
