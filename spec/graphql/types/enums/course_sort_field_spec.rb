# frozen_string_literal: true

module Types
  module Enums
    RSpec.describe CourseSortField do
      let(:enum) { described_class }
      let(:values) { enum.values[sort_method].value }

      describe 'values for Course ID sorting' do
        let(:sort_method) { 'COURSE_ID' }

        it { expect(values).to eq(%i[subject catalog_number]) }
      end

      describe 'values for Department sorting' do
        let(:sort_method) { 'DEPARTMENT' }

        it { expect(values).to eq(%i[subject]) }
      end

      describe 'values for Relevance sorting' do
        let(:sort_method) { 'RELEVANCE' }

        it { expect(values).to eq(%i[score academic_year term_name]) }
      end

      describe 'values for School sorting' do
        let(:sort_method) { 'SCHOOL' }

        it { expect(values).to eq(%i[academic_group]) }
      end

      describe 'values for Semester sorting' do
        let(:sort_method) { 'SEMESTER' }

        it { expect(values).to eq(%i[academic_year term_name]) }
      end

      describe 'values for Title sorting' do
        let(:sort_method) { 'TITLE' }

        it { expect(values).to eq(%i[title_sortable]) }
      end
    end
  end
end
