# frozen_string_literal: true

module Resolvers
  # Return collections of courses based on query arguments
  class CoursesResolver
    # TODO: enable search for additional fields
    FIELD_MAPPING = {
      # 'Course ID' => :course_id,
      'Description' => :course_description_long,
      'Instructor' => %i[first_name last_name],
      # 'Readings' => :readings,
      'Title' => :title
    }.freeze

    def call(_obj, args, _ctx)
      basic_keyword_search(args[:basic_keywords]) if args[:basic_keywords]
      deluxe_keyword_search(args[:deluxe_keywords]) if args[:deluxe_keywords]
    end

    private

    def basic_keyword_search(keywords)
      search = Course.search do
        keywords.each do |keyword|
          fulltext keyword, fields: %i[course_description_long title]
        end

        # TODO: remove hard-coded term_year
        with :term_year, 2018
        paginate page: 1, per_page: 50
      end

      search.results
    end

    def deluxe_keyword_search(keywords)
      search = Course.search do
        keywords.each do |keyword|
          any do
            fulltext keyword[:text], fields: parse_fields(keyword[:fields])
          end
        end

        # TODO: remove hard-coded term_year
        with :term_year, 2018
        paginate page: 1, per_page: 50
      end

      search.results
    end

    def parse_fields(fields)
      # sanitize field input against expected field values
      valid_keys = FIELD_MAPPING.keys & fields

      valid_keys.map { |key| FIELD_MAPPING[key] }.flatten
    end
  end
end
