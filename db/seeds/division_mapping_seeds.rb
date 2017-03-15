require 'csv'

puts "Seeding DivisionMappings!"

csv_text = File.read(Rails.root.join('lib', 'seeds', 'divisionMappings.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  mapping = DivisionMapping.create(
    academic_group: row['academic_group'],
    subject_description: row['subject_description'],
    division: row['division'],
    division_description: row['division_description']
  )

  puts "'#{mapping.division}' saved"
end
