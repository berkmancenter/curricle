require 'rails_helper'

module Resolvers
  RSpec.describe InstructorNames do
    let!(:instructors_2018) { create_pair(:course_instructor, term_year: semester_2018[:term_year]) }
    let!(:instructors_2019) { create_pair(:course_instructor, term_year: semester_2019[:term_year]) }
    let(:outcome) { described_class.run(inputs) }
    let(:semester_2018) { { term_year: 2018 } }
    let(:semester_2019) { { term_year: 2019 } }

    context 'with a single year' do
      let(:inputs) { { semester: semester_2019, past_years: 0 } }

      it 'returns the expected list of instructor names' do
        expect(outcome).to match_array(instructors_2019.map(&:full_name))
      end
    end

    context 'with multiple years' do
      let(:inputs) { { semester: semester_2019, past_years: 1 } }
      let(:instructors) { instructors_2018 + instructors_2019 }

      it 'returns the expected list of instructor names' do
        expect(outcome).to match_array(instructors.map(&:full_name))
      end
    end
  end
end
