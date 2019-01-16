namespace :divisions do
  desc "Update all courses to use latest division mappings"
  task remap: :environment do
    Course.all.each.map(&:'set_division!')
  end
end
