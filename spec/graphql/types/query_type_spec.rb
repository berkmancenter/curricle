# frozen_string_literal: true

RSpec.describe Types::QueryType do
  it { is_expected.to have_field(:count_courses_by_department).of_type('[CoursesByDepartmentType]!') }
  it { is_expected.to have_field(:course).of_type('Course') }
  it { is_expected.to have_field(:course_counts).of_type('[CourseCountType]!') }
  it { is_expected.to have_field(:courses).of_type('[Course]') }
  it { is_expected.to have_field(:coursesConnection).of_type('CoursesConnection') }
  it { is_expected.to have_field(:user_courses).of_type('[Course]!') }
  it { is_expected.to have_field(:courses_connected_by_instructor).of_type('[Course]!') }

  describe 'global method format_as_constant' do
    let(:formatted_string) { format_as_constant('harvard divinity school') }

    it 'formats a string to look like a constant' do
      expect(formatted_string).to eq('HARVARD_DIVINITY_SCHOOL')
    end
  end

  describe 'global method generate_enum_values' do
    it 'generates a collection of formatted values from database records'
  end

  describe 'SortByEnum' do
    let(:enum) { SortByEnum }
    let(:values) { enum.values[sort_method].value }

    it 'has the expected name' do
      expect(enum.name).to eq('SortByEnum')
    end

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
  end
end
