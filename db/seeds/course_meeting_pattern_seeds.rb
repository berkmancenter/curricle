require 'csv'

puts "Seeding CourseMeetingPatterns!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courseMeetings.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  term_year, term_name = row['termDescription'].to_s.split(' ')
  cmp = CourseMeetingPattern.new(
    external_course_id: row['courseId'],
    term_name: term_name,
    term_year: term_year,
    class_section: row['classSection'].to_s =~ /^\d+$/ ? row['classSection'].to_i : row['classSection'],
    class_meeting_number: row['classMtgNbr'],
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

  course = Course.find_by(
    external_course_id: cmp.external_course_id,
    term_name: cmp.term_name,
    term_year: cmp.term_year,
    class_section: cmp.class_section
  )

  if course.nil?
    puts "no course found for #{cmp.external_course_id}"
  else
    cmp.course_id = course.id
  end

  cmp.save
  puts "'#{cmp.external_course_id}-#{cmp.class_section}' saved"
end
