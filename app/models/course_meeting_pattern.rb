class CourseMeetingPattern < ApplicationRecord
  belongs_to :course

  searchable do
    integer :id
    integer :external_course_id
    integer :course_id, references: Course
    string :term_name
    integer :term_year
    string :class_section
    string :class_meeting_number
    integer :meeting_time_start, using:  :extract_hour_from_meeting_time_start
    integer :meeting_time_end, using: :extract_hour_from_meeting_time_end
    boolean :meets_on_monday
    boolean :meets_on_tuesday
    boolean :meets_on_wednesday
    boolean :meets_on_thursday
    boolean :meets_on_friday
    boolean :meets_on_saturday
    boolean :meets_on_sunday
    date :start_date
    date :end_date
    string :external_facility_id
    text :facility_description
  end

  def extract_hour_from_meeting_time_start
    self.meeting_time_start.hour unless self.meeting_time_start.nil?
  end

  def extract_hour_from_meeting_time_end
     self.meeting_time_end.hour unless self.meeting_time_end.nil?
  end


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
