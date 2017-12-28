require 'smarter_csv'

puts "Seeding CourseInstructors!"

course_instructors = SmarterCSV.process(Rails.root.join('lib', 'seeds', 'course_instructors.csv'), chunk_size: 1000)  do |chunk|
  chunk.each do |row|
    term_year, term_name = row[:term_description].to_s.split(' ')
    ci = CourseInstructor.new(
      external_course_id: row[:course_id],
      term_name: term_name,
      term_year: term_year,
      class_section: row[:class_section].to_s =~ /^\d+$/ ? row[:class_section].to_i : row[:class_section],
      class_meeting_number: row[:class_meeting_number],
      instructor_role: row[:instructor_role],
      print_instructor_flag: row[:print_instructor_flag],
      first_name: row[:instructor_first_name],
      middle_name: row[:instructor_middle_name],
      last_name: row[:instructor_last_name],
      name_prefix: row[:instructor_name_prefix],
      name_suffix: row[:instructor_name_suffix],
      email: row[:instructor_email]
    )

    course = Course.find_by(
      external_course_id: ci.external_course_id,
      term_name: ci.term_name,
      term_year: ci.term_year
    )

    if course.nil?
      puts "no course found for #{ci.external_course_id}"
    else
      ci.course_id = course.id
    end

    ci.save
    puts "'#{ci.last_name}' saved"
  end
end
