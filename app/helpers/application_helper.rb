# frozen_string_literal: true

module ApplicationHelper
  # intended to convert digits/strings of 0..23 to a 12-hour am/pm display (e.g. 14 => "02:00pm")
  def pretty_hour(hour)
    hour = hour.to_i

    text = if hour == 0
             '12:00am'
           elsif hour < 12
             "#{hour}:00am"
           elsif hour > 12
             "#{hour - 12}:00pm"
           else
             '12:00pm'
           end

    text.prepend('0') if text.match?(/^\d\:/)

    text
  end

  # returns the current semester (e.g. "Spring 2017")
  def current_semester(safe: false)
    year = Time.now.year
    name = Time.now.month < 6 ? 'Spring' : 'Fall'
    safe ? "#{name}_#{year}" : "#{name} #{year}"
  end

  def semester_map(starts_at = nil)
    starts_at ||= current_semester
    name, year = starts_at.split(' ')
    year = year.to_i

    if name == 'Spring'
      # if current/provided semester is Spring, start with the fall of the previous year
      year -= 1
    end

    years = []

    4.times do
      current_year = []

      current_year << "Fall #{year}"

      year += 1
      current_year << "Spring #{year}"
      years << current_year
    end

    years
  end

  def sunspot_search(search_filters, type)
    res = Sunspot.search(Course) do
      adjust_solr_params do |params|
        params[:q] = params[:q].gsub(/AND _query/, 'OR _query') if params[:q].present?
      end
      search_filters[:keywords].each do |key, value|
        fields = []

        if search_filters[:keyword_options][key].present?
          search_filters[:keyword_options][key].each do |field|
            map = Course.keyword_options_map[field.to_sym]
            fields << map[:db_field][:columns]
          end
        end

        fields_with_boost = {}
        fields = fields.flatten.map(&:to_sym)
        fields.each do |field|
          fields_with_boost[field] = search_filters[:keyword_weights][key]
        end

        keywords value, fields: fields do
          boost_fields fields_with_boost
        end

        paginate page: 1, per_page: Course.count
      end

      with(:subject_description, search_filters[:subject]) unless search_filters[:subject] == 'all'
      with(:academic_group, search_filters[:school]) unless search_filters[:school] == 'all'
      with(:class_academic_org_description, search_filters[:department]) unless search_filters[:department] == 'all'

      with(:component, search_filters[:type]) unless search_filters[:type] == 'all'
      with(:units_maximum).less_than(search_filters[:units][:max]) unless search_filters[:units][:max] == 'any'
      with(:units_maximum).greater_than(search_filters[:units][:min]) unless search_filters[:units][:max] == 'any'

      name, year = search_filters[:term].split('_')
      with(:term_name, name)
      with(:term_year, year)

      if type == :courses
        array_days = %i[monday tuesday wednesday thursday friday]
        array_days.each do |day_of_week|
          unless search_filters[:times][day_of_week][:min] == 'any'
            all_of do
              with("meets_on_#{day_of_week}".to_sym, true)
              with(:meeting_time_start).greater_than(search_filters[:times][day_of_week][:min])
            end
          end
          next if search_filters[:times][day_of_week][:max] == 'any'
          all_of do
            with("meets_on_#{day_of_week}", true)
            with(:meeting_time_start).less_than(search_filters[:times][day_of_week][:max])
          end
        end
      end
      paginate page: 1, per_page: 50
    end
    return Course.return_as_relation(res) if type == :path
    res
  end
end
