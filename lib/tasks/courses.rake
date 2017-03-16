namespace :divisions do
  desc "Update all courses to use latest division mappings"
  task remap: :environment do
    Course.all.each.map(&:'set_division!')
  end

  desc "Re-seed division mappings from divisionMappings.csv (destroys existing mappings)"
  task reseed: :environment do
    ActiveRecord::Base.transaction do
      DivisionMapping.destroy_all
      require_relative '../../db/seeds/division_mapping_seeds'
    end
  end
end
