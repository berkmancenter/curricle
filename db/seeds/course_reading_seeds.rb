require 'csv'

puts "Seeding CourseReadings!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'courseReadings.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  cr = CourseReading.new(
    external_course_id: row['instance_id'],
    external_citation_id: row['citation_id'],
    title: row['title'],
    author_first_name: row['author_first_name'],
    author_last_name: row['author_last_name'],
    url: row['url'],
    annotation: row['student_annotation'],
    required: row['required'] == "Y"
  )

  course = Course.find_by(
    external_course_id: cr.external_course_id
  )

  if course.nil?
    puts "no course found for #{cr.external_course_id}"
  else
    cr.course_id = course.id
    cr.save
    puts "'#{cr.title}' saved"
  end

end
