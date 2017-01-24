class RecommendationService
  def initialize(query: query, max_units: max_units)
    @query = query
    @max_units = max_units.to_i
  end

  def generate
    recommendations = []

    available = @query.to_a.shuffle
    units_remaining = @max_units
    while units_remaining > 0 && available.length > 0 do
      # remove any courses from consideration that are worth more units than we have remaining
      available.delete_if { |r| r.course.units_maximum > units_remaining }

      # select a course
      rec = available.pop
      break if rec.nil?
      recommendations << rec

      # decrement units remaining
      units_remaining -= rec.course.units_maximum

      # remove any courses from consideration in future loops that would overlap the course we just selected
      available.keep_if { |r|
        (r.meets_on_monday == false || r.meets_on_monday != rec.meets_on_monday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_tuesday == false || r.meets_on_tuesday != rec.meets_on_tuesday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_wednesday == false || r.meets_on_wednesday != rec.meets_on_wednesday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_thursday == false || r.meets_on_thursday != rec.meets_on_thursday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start)) &&
          (r.meets_on_friday == false || r.meets_on_friday != rec.meets_on_friday || (r.meeting_time_start >= rec.meeting_time_end || r.meeting_time_end <= rec.meeting_time_start))
      }
    end

    recommendations
  end
end
