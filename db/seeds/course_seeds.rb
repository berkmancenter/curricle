require 'smarter_csv'

puts "Seeding Courses!"

courses = SmarterCSV.process(Rails.root.join('lib', 'seeds', 'courses.csv'), chunk_size: 1000)  do |chunk|
  chunk.each do |row|
    term_year, term_name = row[:term_description].to_s.split(' ')
    c = Course.find_or_create_by(
      external_course_id: row[:course_id],
      course_description: row[:course_descr],
      title: row[:course_title_long],
      term_name: term_name,
      term_year: term_year,
      academic_year: row[:academic_year],
      class_section: row[:class_section].to_s =~ /^\d+$/ ? row[:class_section].to_i : row[:class_section],
      component: row[:component_description],
      subject: row[:subject],
      subject_description: row[:subject_description],
      subject_academic_org_description: row[:subject_acad_org_description],
      class_academic_org_description: row[:class_acad_org_description],
      academic_group: row[:acad_group],
      academic_group_description: row[:acad_group_description],
      grading_basis_description: row[:grading_gasis_description],
      term_pattern_code: row[:term_pattern_code],
      term_pattern_description: row[:term_pattern_description],
      units_maximum: row[:units_maximum],
      catalog_number: row[:catalog_number],
      course_description_long: row[:course_descrlong],
      course_note: row[:course_note]
    )
    puts "'#{c.course_description}' saved"
  end
end
