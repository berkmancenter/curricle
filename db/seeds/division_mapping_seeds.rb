require 'smarter_csv'

puts "Seeding DivisionMappings!"

dm = SmarterCSV.process(Rails.root.join('lib', 'seeds', 'divisionMappings.csv'))
dm.each do |row|
  mapping = DivisionMapping.create(
    academic_group: row[:academic_group],
    subject_description: row[:subject_description],
    division: row[:division],
    division_description: row[:division_description]
  )

  puts "'#{mapping.division}' saved"
end
