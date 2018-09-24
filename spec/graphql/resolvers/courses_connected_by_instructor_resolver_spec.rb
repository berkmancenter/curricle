# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::CoursesConnectedByInstructorResolver do
  describe '#call' do
    subject { call }

    let(:args) { { semester: semester, name: name } }
    let(:call) { resolver.call(nil, args, nil) }
    let(:resolver) { described_class.new }
    let(:term_name) { 'SPRING' }
    let(:term_year) { 2018 }
    let(:semester) { { term_name: term_name, term_year: term_year } }

    before do
      allow(resolver).to receive(:search_for_instructor) { OpenStruct.new(results: search_results) }
    end

    context 'when the instructor name does not match any results' do
      let(:name) { 'John Doe' }
      let(:search_results) { [] }

      it { is_expected.to be_empty }
    end

    context 'when instructor is returned in search results' do
      let(:first_name) { 'Primary' }
      let(:last_name) { 'Instructor' }
      let(:name) { "#{first_name} #{last_name}" }
      let(:course_instructor) { create(:course_instructor, first_name: first_name, last_name: last_name, **semester) }
      let(:search_results) { [course_instructor] }

      context 'when they have not co-taught a course' do
        it { is_expected.to be_empty }
      end

      context 'when they have co-taught a course with one other instructor' do
        before do
          create(:course_instructor, course: course_instructor.course, **semester)
          create_pair(:course_instructor, **semester)
          create_pair(:course, **semester)
        end

        it { is_expected.to contain_exactly(course_instructor.course) }
      end

      context 'when they have co-taught a course that has more than 8 instructors' do
        before do
          create_list(:course_instructor, 10, course: course_instructor.course, **semester)
          create_pair(:course_instructor, **semester)
          create_pair(:course, **semester)
        end

        it { is_expected.to be_empty }
      end
    end
  end
end
