require 'csv'

puts "Seeding CourseMeetingPatterns!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courseInstructors.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  course = Course.find_by(external_course_id: row['courseId'])
  next if course.nil?

  c = CourseInstructor.find_or_create_by(
    course_id: course.id,
    external_course_id: row['courseId'],
    instructor_role: row['instructorRole'],
    print_instructor_flag: row['printInstructorFlag'],
    first_name: row['instructorFirstName'],
    middle_name: row['instructorMiddleName'],
    last_name: row['instructorLastName'],
    name_prefix: row['instructorNamePrefix'],
    name_suffix: row['instructorNameSuffix'],
    email: row['instructorEmail']
  )
  puts "'#{c.last_name}' saved"
end
