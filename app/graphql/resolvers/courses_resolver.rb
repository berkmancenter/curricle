# frozen_string_literal: true

module Resolvers
  # Return collections of courses based on query arguments
  class CoursesResolver
    # TODO: enable search for additional fields
    FIELD_MAPPING = {
      'DESCRIPTION' => :course_description_long,
      'INSTRUCTOR' => %i[first_name last_name],
      # 'Readings' => :readings,
      'TITLE' => :title
    }.freeze

    def call(_obj, args, _ctx)
      search =
        if args[:course_ids] && args[:course_ids].any?
          search_by_ids(args[:course_ids])
        elsif args[:deluxe_keywords] && args[:deluxe_keywords].any?
          search_by_keywords(args[:deluxe_keywords])
        end

      if search
        search.results
      end
    end

    def search_by_keywords(keywords)
      return Course.search do
        keywords.each { |keyword| add_keyword_to_search(self, keyword) }
        order_by(:term_year, :desc)
        paginate page: 1, per_page: 50
      end
    end

    def search_by_ids(course_ids)
      return Course.search do
        with :id, course_ids
        paginate page: 1, per_page: course_ids.length
      end
    end

    private

    # Detect Course ID keywords in the format of "GENETIC 333"
    def course_id?(string)
      string =~ /\A[a-zA-Z]+ \d+\z/
    end

    def add_keyword_to_search(sunspot, keyword)
      sunspot.instance_eval do
        if keyword[:fields].include?('COURSE_ID') && course_id?(keyword[:text])
          search_by_course_id(self, keyword)
        elsif keyword[:fields] == ['ID'] && keyword[:text] =~ /\A\d+\z/
          with :id, keyword[:text].to_i
        elsif keyword[:fields] != ['COURSE_ID']
          search_by_fulltext(self, keyword)
        else
          with :id, 0 # prevent inadvertently returning all courses
        end
      end
    end

    def search_by_course_id(sunspot, keyword)
      subject, catalog_number = keyword[:text].split

      sunspot.instance_eval do
        with :subject, subject.upcase
        with :catalog_number, catalog_number.to_i
      end
    end

    def search_by_fulltext(sunspot, keyword)
      sunspot.instance_eval do
        any do
          fields = keyword[:fields].map { |key| FIELD_MAPPING[key] }.flatten

          fulltext keyword[:text], fields: fields
        end
      end
    end
  end
end
