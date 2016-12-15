# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161213024412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_instructors", force: :cascade do |t|
    t.integer  "external_course_id"
    t.integer  "course_id"
    t.string   "instructor_role"
    t.string   "print_instructor_flag"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "name_prefix"
    t.string   "name_suffix"
    t.string   "email"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "course_meeting_patterns", force: :cascade do |t|
    t.integer  "external_course_id"
    t.integer  "course_id"
    t.datetime "meeting_time_start"
    t.datetime "meeting_time_end"
    t.boolean  "meets_on_monday"
    t.boolean  "meets_on_tuesday"
    t.boolean  "meets_on_wednesday"
    t.boolean  "meets_on_thursday"
    t.boolean  "meets_on_friday"
    t.boolean  "meets_on_saturday"
    t.boolean  "meets_on_sunday"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "external_facility_id"
    t.text     "facility_description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "courses", force: :cascade do |t|
    t.integer  "external_course_id"
    t.text     "course_description"
    t.string   "title"
    t.string   "term_name"
    t.integer  "term_year"
    t.integer  "academic_year"
    t.string   "component"
    t.integer  "prereq"
    t.string   "subject"
    t.text     "subject_description"
    t.text     "subject_academic_org_description"
    t.string   "academic_group"
    t.text     "academic_group_description"
    t.text     "grading_basis_description"
    t.string   "term_pattern_code"
    t.text     "term_pattern_description"
    t.integer  "units_maximum"
    t.integer  "catalog_number"
    t.text     "course_description_long"
    t.text     "course_note"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_courses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.boolean  "include_in_path"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "external_user_id"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "major"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_foreign_key "course_instructors", "courses"
  add_foreign_key "course_meeting_patterns", "courses"
  add_foreign_key "courses", "courses", column: "prereq"
  add_foreign_key "tags", "courses"
  add_foreign_key "tags", "users"
  add_foreign_key "user_courses", "courses"
  add_foreign_key "user_courses", "users"
end
