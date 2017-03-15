module ApplicationHelper
  # intended to convert digits/strings of 0..23 to a 12-hour am/pm display (e.g. 14 => "02:00pm")
  def pretty_hour(hour)
    hour = hour.to_i

    if hour == 0
      text = "12:00am"
    elsif hour < 12
      text = "#{hour}:00am"
    elsif hour > 12
      text = "#{hour - 12}:00pm"
    else
      text = "12:00pm"
    end

    text.prepend("0") if text =~ /^\d\:/

    text
  end

  # returns the current semester (e.g. "Spring 2017")
  def current_semester(safe: false)
    year = Time.now.year
    name = Time.now.month < 6 ? "Spring" : "Fall"
    safe ? "#{name}_#{year}" : "#{name} #{year}"
  end

  def semester_map(starts_at = nil)
    starts_at ||= current_semester
    name, year = starts_at.split(" ")
    year = year.to_i

    if name == "Spring"
      # if current/provided semester is Spring, start with the fall of the previous year
      year = year - 1
    end

    years = []

    4.times do
      current_year = []

      current_year << "Fall #{year}"

      year = year + 1
      current_year << "Spring #{year}"
      years << current_year
    end

    years
  end

  def sunspot_search(search_filters, type)
    res = Sunspot.search(Course) do
        search_filters[:keywords].each do |key, value|
          fields = []
          search_filters[:keyword_options][key].each do |field|
            map = Course.keyword_options_map[field.to_sym]
            fields << map[:db_field][:columns]
          end
          keywords value, fields: fields.flatten.map(&:to_sym)
        end

        with(:subject_description, search_filters[:subject]) unless search_filters[:subject]=="all"
        with(:academic_group, search_filters[:school]) unless search_filters[:school]=="all"
        with(:class_academic_org_description, search_filters[:department]) unless  search_filters[:department]=="all"
        
        with(:component, search_filters[:type]) unless search_filters[:type]=="all"
        with(:units_maximum).less_than(search_filters[:units][:max]) unless search_filters[:units][:max]=="any"
        with(:units_maximum).greater_than(search_filters[:units][:min]) unless search_filters[:units][:max]=="any"

        if type == :path
          with(:term_name, search_filters[:term][0..5])
        end

        if type == :courses

          unless search_filters[:times][:monday][:min]=="any"
            all_of do
            with(:meets_on_monday, true)
            with(:meeting_time_start).greater_than(search_filters[:times][:monday][:min])
            end
          end
          unless search_filters[:times][:monday][:max]=="any"
            all_of do
            with(:meets_on_monday, true)
            with(:meeting_time_start).less_than(search_filters[:times][:monday][:max])
            end
          end

          unless search_filters[:times][:tuesday][:min]=="any"
            all_of do
            with(:meets_on_tuesday, true)
            with(:meeting_time_start).greater_than(search_filters[:times][:tuesday][:min])
            end
          end
          unless search_filters[:times][:tuesday][:max]=="any"
            all_of do
            with(:meets_on_tuesday, true)
            with(:meeting_time_start).less_than(search_filters[:times][:tuesday][:max])
            end
          end

          unless search_filters[:times][:wednesday][:min]=="any"
            all_of do
            with(:meets_on_wednesday, true)
            with(:meeting_time_start).greater_than(search_filters[:times][:wednesday][:min])
            end
          end
          unless search_filters[:times][:wednesday][:max]=="any"
            all_of do
            with(:meets_on_wednesday, true)
            with(:meeting_time_start).less_than(search_filters[:times][:wednesday][:max])
            end
          end

          unless search_filters[:times][:thursday][:min]=="any"
            all_of do
            with(:meets_on_thursday, true)
            with(:meeting_time_start).greater_than(search_filters[:times][:thursday][:min])
            end
          end
          unless search_filters[:times][:thursday][:max]=="any"
            all_of do
            with(:meets_on_thursday, true)
            with(:meeting_time_start).less_than(search_filters[:times][:thursday][:max])
            end
          end

          unless search_filters[:times][:friday][:min]=="any"
            all_of do
            with(:meets_on_friday, true)
            with(:meeting_time_start).greater_than(search_filters[:times][:friday][:min])
            end
          end
          unless search_filters[:times][:friday][:max]=="any"
            all_of do
            with(:meets_on_friday, true)
            with(:meeting_time_start).less_than(search_filters[:times][:friday][:max])
            end
          end
        end

      end
      query = Course.return_as_relation(res)
      query
  end

  def apply_common_filters(query, filters)
    term, year = filters[:term].split('_')
    query = query.where(term_name: term, term_year: year)

    unless filters[:school] == 'all'
      query = query.where('courses.academic_group': filters[:school])
    end

    unless filters[:department] == 'all'
      query = query.where('courses.class_academic_org_description': filters[:department])
    end

    unless filters[:subject] == 'all'
      query = query.where('courses.subject_description': filters[:subject])
    end

    unless filters[:type] == 'all'
      query = query.where('courses.component': filters[:type])
    end

    unless filters[:units][:min] == 'any'
      query = query.where("courses.units_maximum >= ?", filters[:units][:min])
    end

    unless filters[:units][:max] == 'any'
      query = query.where("courses.units_maximum <= ?", filters[:units][:max])
    end

    query
  end
end
