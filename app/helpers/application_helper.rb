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

        name, year = search_filters[:term].split('_')
        with(:term_name, name)
        with(:term_year, year)


        if type == :courses
          array_days = [:monday, :tuesday, :wednesday, :thursday, :friday]
          array_days.each do |day_of_week| 

            unless search_filters[:times][day_of_week][:min]=="any"
              all_of do
              with("meets_on_#{day_of_week}".to_sym, true)
              with(:meeting_time_start).greater_than(search_filters[:times][day_of_week][:min])
              end
            end
            unless search_filters[:times][day_of_week][:max]=="any"
              all_of do
              with("meets_on_#{day_of_week}", true)
              with(:meeting_time_start).less_than(search_filters[:times][day_of_week][:max])
              end
            end
          end
         end
      end
      query = Course.return_as_relation(res)
      query
  end
<<<<<<< HEAD
=======

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
>>>>>>> 6ac15bd7ae2b735cc2b3bfd32b690de07268d18c
end
