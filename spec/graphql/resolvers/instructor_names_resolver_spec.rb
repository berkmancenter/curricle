# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::InstructorNamesResolver do
  describe '#call' do
    subject { call }

    let(:args) { { semester: semester } }
    let(:call) { resolver.call(nil, args, nil) }
    let(:resolver) { described_class.new }
    let(:term_name) { 'SPRING' }
    let(:term_year) { 2019 }
    let(:semester) { { term_name: term_name, term_year: term_year } }
    let!(:instructors) do
      [
        create(:course_instructor, first_name: 'John', term_name: term_name, term_year: term_year),
        create(:course_instructor, first_name: 'Jack', term_name: term_name, term_year: term_year)
      ]
    end
    let!(:recent_instructor) { create(:course_instructor, first_name: 'Patrick', term_year: 2017) }
    let(:instructor_names) { instructors.map(&:full_name) }

    before do
      create(:course_instructor, term_year: 2008)
    end

    context 'when searching by semester without including past years' do
      it { is_expected.to match_array(instructor_names) }
    end

    context 'when searching by semester and including past years' do
      let(:args) { { semester: semester, past_years: 10 } }

      it { is_expected.to match_array(instructor_names.push(recent_instructor.full_name)) }
    end
  end
end
