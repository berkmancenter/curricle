class CourseMeetingPattern < ApplicationRecord
  belongs_to :course

  def self.hours_range
    (8..20)
  end

  def semester(safe: false)
    safe ? "#{term_name}_#{term_year}" : "#{term_name} #{term_year}"
  end

  def meeting_days
    days = []

    days << "M" if meets_on_monday
    days << "T" if meets_on_tuesday
    days << "W" if meets_on_wednesday
    days << "Th" if meets_on_thursday
    days << "F" if meets_on_friday

    days
  end

  def minutes_past(hour = 7)
    return 0 if meeting_time_start.blank?
    morning = meeting_time_start.change(hour: hour)
    (meeting_time_start - morning) / 60
  end

  def length
    (meeting_time_end - meeting_time_start) / 60
  end

  def schedule
    return "#{meeting_days.join(" / ")}" if meeting_time_start.blank? || meeting_time_end.blank?
    "#{meeting_days.join(" / ")} #{meeting_time_start.strftime("%l:%M")} - #{meeting_time_end.strftime("%l:%M %p")}"
  end
end
