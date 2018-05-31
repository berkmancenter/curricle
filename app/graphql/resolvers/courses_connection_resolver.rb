# frozen_string_literal: true

module Resolvers
  # Return collections of courses based on query arguments
  class CoursesConnectionResolver
    # TODO: enable search for additional fields
    FIELD_MAPPING = {
      'DESCRIPTION' => :course_description_long,
      'INSTRUCTOR' => %i[first_name last_name],
      'NOTES' => :course_note,
      # 'Readings' => :readings,
      'TITLE' => :title
    }.freeze

    def call(_obj, args, ctx)
      search = search_by_keywords(args)

      return if search.blank?

      if args[:annotated].present?
        filter_by_annotation(search.results, ctx[:current_user])
      else
        search
      end
    end

    def search_by_keywords(args)
      Course.search do
        with :id, args[:ids] if args[:ids].present?
        args[:deluxe_keywords]&.each { |keyword| add_keyword_to_search(self, keyword) }
        apply_filters(self, args)
        apply_time_ranges(self, args[:time_ranges]) if args[:time_ranges]
        semester_range_scope(self, args[:semester_range])
        sort_order(self, args[:sort_by])
        paginate page: (args[:page] || 1), per_page: (args[:per_page] || 50)
        facet :academic_group
        facet :subject_academic_org_description
        facet :component
        facet :subject
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

    # FIXME: find a way to refactor this into smaller methods by passing sunspot instance around
    def semester_range_scope(sunspot, semester_range)
      return if semester_range.blank?

      sunspot.instance_eval do
        if semester_range.end.blank?
          with :term_name, semester_range.start.term_name
          with :term_year, semester_range.start.term_year
        else
          intermediate_years = (semester_range.start.term_year..semester_range.end.term_year).to_a[1...-1]

          any_of do
            all_of do
              with :term_name, start_year_term_scope(semester_range.start.term_name)
              with :term_year, semester_range.start.term_year
            end

            all_of do
              with :term_name, end_year_term_scope(semester_range.end.term_name)
              with :term_year, semester_range.end.term_year
            end

            if intermediate_years.any?
              all_of do
                with :term_name, TermNameEnum.values.values.map(&:value)
                with :term_year, intermediate_years
              end
            end
          end
        end
      end
    end

    def start_year_term_scope(term_name)
      case term_name
      when 'Spring'
        %w[Spring Summer Fall]
      when 'Summer'
        %w[Summer Fall]
      when 'Fall'
        %w[Fall]
      end
    end

    def end_year_term_scope(term_name)
      case term_name
      when 'Spring'
        %w[Spring]
      when 'Summer'
        %w[Spring Summer]
      when 'Fall'
        %w[Spring Summer Fall]
      end
    end

    def sort_order(sunspot, sort_by)
      sunspot.instance_eval do
        sort_by&.each do |sort_method|
          sort_order = sort_method == :score ? :desc : :asc
          order_by(sort_method, sort_order)
        end
      end
    end

    def apply_filters(sunspot, args)
      sunspot.instance_eval do
        with :class_section, '1' # all class_sections should be 1
        with :academic_group, Array(args[:schools])
        with :subject_academic_org_description, Array(args[:departments])
        with :subject, Array(args[:subjects])
        with :component, Array(args[:components])
      end
    end

    def filter_by_annotation(courses, current_user)
      return courses if current_user.blank?

      annotated_course_ids = current_user.annotations.pluck(:course_id)

      courses.select { |course| course.id.in?(annotated_course_ids) }
    end

    def apply_time_ranges(sunspot, times)
      return unless times.any?

      # times is an array of days of week and start/end values for
      # valid meeting times.

      # per definition, if a day is not included in this search, we
      # *must* exclude anything which meets on this particular day.

      # so for each day, we must either include it in the search or
      # explicitly exclude it from the search.

      # convert to a more useful format...
      lkup = Hash[times.collect { |t| [t[:day_name], [t[:time_start], t[:time_end]]] }]
      days = %w(monday tuesday wednesday thursday friday)

      excludes = []
      includes = []

      days.each do |d|
        if lkup[d.capitalize]
          includes.push(d)
        else
          excludes.push(d)
        end
      end

      sunspot.instance_eval do
        excludes.each{ |d| with "meets_on_#{d}", false }
        any_of do
          includes.each{
            |d|
            any_of do
              with "meets_on_#{d}", false
              all_of do
                range = lkup[d.capitalize]
                with "meets_on_#{d}", true
                # with(:meeting_time_start).greater_than_or_equal_to(range[0])
                # with(:meeting_time_end).less_than_or_equal_to(range[1])
                any_of do
                  (range[0]..24).to_a.each{|a| with(:meeting_time_start, a) }
                end
                any_of do
                  (0..range[1]).to_a.each{|a| with(:meeting_time_end, a) }
                end
              end
            end
          }
        end
      end
    end
  end
end
