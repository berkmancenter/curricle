module Resolvers
  class InstructorNames
    def self.run(semester:, past_years:)
      term_year_range = determine_term_year_range(semester, past_years)

      CourseInstructor
        .where(term_year: term_year_range)
        .group(:first_name, :last_name)
        .pluck(:first_name, :last_name)
        .map { |name| name.join(' ') }
    end

    def self.determine_term_year_range(semester, past_years)
      term_year_max = semester[:term_year]
      term_year_min = term_year_max - past_years

      term_year_min..term_year_max
    end
  end
end
