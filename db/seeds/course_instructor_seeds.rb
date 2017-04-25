require 'csv'

puts "Seeding CourseInstructors!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courseInstructors.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  term_year, term_name = row['termDescription'].to_s.split(' ')
  ci = CourseInstructor.new(
    external_course_id: row['courseId'],
    term_name: term_name,
    term_year: term_year,
    class_section: row['classSection'].to_s =~ /^\d+$/ ? row['classSection'].to_i : row['classSection'],
    class_meeting_number: row['classMeetingNumber'],
    instructor_role: row['instructorRole'],
    print_instructor_flag: row['printInstructorFlag'],
    first_name: row['instructorFirstName'],
    middle_name: row['instructorMiddleName'],
    last_name: row['instructorLastName'],
    name_prefix: row['instructorNamePrefix'],
    name_suffix: row['instructorNameSuffix'],
    email: row['instructorEmail']
  )

  course = Course.find_by(
    external_course_id: ci.external_course_id,
    term_name: ci.term_name,
    term_year: ci.term_year,
    class_section: ci.class_section
  )

  if course.nil?
    puts "no course found for #{ci.external_course_id}"
  else
    ci.course_id = course.id
  end

  ci.save
  puts "'#{ci.last_name}' saved"
end
