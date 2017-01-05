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
end
