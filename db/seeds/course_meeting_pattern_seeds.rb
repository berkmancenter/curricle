require 'csv'

puts "Seeding CourseInstructors!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courseMeetings.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  course = Course.find_by(external_course_id: row['courseId'])
  next if course.nil?

  c = CourseMeetingPattern.find_or_create_by(
    course_id: course.id,
    external_course_id: row['courseId'],
    meeting_time_start: row['meetingTimeStart'] ? Time.strptime(row['meetingTimeStart'], '%d-%b-%y %I.%M.%S.000000000 %P') : nil,
    meeting_time_end: row['meetingTimeEnd'] ? Time.strptime(row['meetingTimeEnd'], '%d-%b-%y %I.%M.%S.000000000 %P') : nil,
    meets_on_monday: row['mon'] == 'Y',
    meets_on_tuesday: row['tues'] == 'Y',
    meets_on_wednesday: row['wed'] == 'Y',
    meets_on_thursday: row['thurs'] == 'Y',
    meets_on_friday: row['fri'] == 'Y',
    meets_on_saturday: row['sat'] == 'Y',
    meets_on_sunday: row['sun'] == 'Y',
    start_date: Date.parse(row['startDt']),
    end_date: Date.parse(row['endDt']),
    external_facility_id: row['facilityId'],
    facility_description: row['facilityDescription']
  )
  puts "'#{c.external_course_id}' meeting pattern saved"
end
