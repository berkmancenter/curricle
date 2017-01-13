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
  def current_semester
    year = Time.now.year
    name = Time.now.month < 6 ? "Spring" : "Fall"
    "#{name} #{year}"
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
end
