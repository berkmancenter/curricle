require 'csv'

puts "Seeding Courses!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courses.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  term_year, term_name = row['termDescription'].to_s.split(' ')
  c = Course.create(
    external_course_id: row['courseId'],
    course_description: row['courseDescr'],
    title: row['courseTitleLong'],
    term_name: term_name,
    term_year: term_year,
    academic_year: row['academicYear'],
    class_section: row['classSection'].to_s =~ /^\d+$/ ? row['classSection'].to_i : row['classSection'],
    component: row['componentDescription'],
    subject: row['subject'],
    subject_description: row['subjectDescription'],
    subject_academic_org_description: row['subjectAcadOrgDescription'],
    academic_group: row['acadGroup'],
    academic_group_description: row['acadGroupDescription'],
    grading_basis_description: row['gradingBasisDescription'],
    term_pattern_code: row['termPatternCode'],
    term_pattern_description: row['termPatternDescription'],
    units_maximum: row['unitsMaximum'],
    catalog_number: row['catalogNumber'],
    course_description_long: row['courseDescrlong'],
    course_note: row['courseNote']
  )
  puts "'#{c.title}' saved"
end

