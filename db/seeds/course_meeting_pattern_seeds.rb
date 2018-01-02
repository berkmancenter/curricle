require 'smarter_csv'

puts "Seeding CourseMeetingPatterns!"

course_meeting_patterns = SmarterCSV.process(Rails.root.join('lib', 'seeds', 'course_meeting_patterns.csv'), chunk_size: 1000)  do |chunk|
  chunk.each do |row|
    term_year, term_name = row[:term_description].to_s.split(' ')
    cmp = CourseMeetingPattern.new(
      external_course_id: row[:course_id],
      term_name: term_name,
      term_year: term_year,
      class_section: row[:class_section].to_s =~ /^\d+$/ ? row[:class_section].to_i : row[:class_section],
      class_meeting_number: row[:class_mtg_nbr],
      meeting_time_start: row[:meeting_time_start] ? Time.strptime(row[:meeting_time_start], '%d-%b-%y %I.%M.%S.000000000 %P') : nil,
      meeting_time_end: row[:meeting_time_end] ? Time.strptime(row[:meeting_time_end], '%d-%b-%y %I.%M.%S.000000000 %P') : nil,
      meets_on_monday: row[:mon] == 'Y',
      meets_on_tuesday: row[:tues] == 'Y',
      meets_on_wednesday: row[:wed] == 'Y',
      meets_on_thursday: row[:thurs] == 'Y',
      meets_on_friday: row[:fri] == 'Y',
      meets_on_saturday: row[:sat] == 'Y',
      meets_on_sunday: row[:sun] == 'Y',
      start_date: row[:start_dt] ? Date.parse(row[:start_dt]).strftime("%d/%m/%Y") : row[:start_dt],
      end_date: row[:end_dt] ? Date.parse(row[:end_dt]).strftime("%d/%m/%Y") : row[:end_dt],
      external_facility_id: row[:facility_id],
      facility_description: row[:facility_description]
    )

    course = Course.find_by(
      external_course_id: cmp.external_course_id,
      term_name: cmp.term_name,
      term_year: cmp.term_year
    )

    if course.nil?
      puts "no course found for #{cmp.external_course_id}"
    else
      cmp.course_id = course.id
    end
    cmp.save
    puts "'#{cmp.external_course_id}-#{cmp.class_section}' saved"
  end
end
