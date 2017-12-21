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

ActiveRecord::Schema.define(version: 20171221085445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gin"

  create_table "course_instructors", id: :serial, force: :cascade do |t|
    t.integer "external_course_id"
    t.integer "course_id"
    t.string "term_name"
    t.integer "term_year"
    t.string "class_section"
    t.string "class_meeting_number"
    t.string "instructor_role"
    t.string "print_instructor_flag"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "name_prefix"
    t.string "name_suffix"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_meeting_patterns", id: :serial, force: :cascade do |t|
    t.integer "external_course_id"
    t.integer "course_id"
    t.string "term_name"
    t.integer "term_year"
    t.string "class_section"
    t.string "class_meeting_number"
    t.datetime "meeting_time_start"
    t.datetime "meeting_time_end"
    t.boolean "meets_on_monday"
    t.boolean "meets_on_tuesday"
    t.boolean "meets_on_wednesday"
    t.boolean "meets_on_thursday"
    t.boolean "meets_on_friday"
    t.boolean "meets_on_saturday"
    t.boolean "meets_on_sunday"
    t.date "start_date"
    t.date "end_date"
    t.string "external_facility_id"
    t.text "facility_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_meeting_patterns_on_course_id"
    t.index ["meets_on_friday"], name: "index_course_meeting_patterns_on_meets_on_friday"
    t.index ["meets_on_monday"], name: "index_course_meeting_patterns_on_meets_on_monday"
    t.index ["meets_on_saturday"], name: "index_course_meeting_patterns_on_meets_on_saturday"
    t.index ["meets_on_sunday"], name: "index_course_meeting_patterns_on_meets_on_sunday"
    t.index ["meets_on_thursday"], name: "index_course_meeting_patterns_on_meets_on_thursday"
    t.index ["meets_on_tuesday"], name: "index_course_meeting_patterns_on_meets_on_tuesday"
    t.index ["meets_on_wednesday"], name: "index_course_meeting_patterns_on_meets_on_wednesday"
  end

  create_table "course_readings", id: :serial, force: :cascade do |t|
    t.integer "external_course_id"
    t.integer "external_citation_id"
    t.integer "course_id"
    t.string "title"
    t.string "author_last_name"
    t.string "author_first_name"
    t.string "url"
    t.text "annotation"
    t.boolean "required", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.integer "external_course_id"
    t.string "title"
    t.string "term_name"
    t.integer "term_year"
    t.integer "academic_year"
    t.string "class_section"
    t.string "component"
    t.integer "prereq"
    t.string "subject"
    t.text "subject_description"
    t.text "subject_academic_org_description"
    t.string "academic_group"
    t.text "academic_group_description"
    t.text "grading_basis_description"
    t.string "term_pattern_code"
    t.text "term_pattern_description"
    t.integer "units_maximum"
    t.integer "catalog_number"
    t.text "course_description"
    t.text "course_description_long"
    t.text "course_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "class_academic_org_description"
    t.string "division"
    t.string "division_description"
    t.index "to_tsvector('english'::regconfig, course_description_long)", name: "index_courses_on_to_tsvector_english_course_description_long", using: :gin
    t.index ["class_section"], name: "index_courses_on_class_section"
    t.index ["course_note"], name: "index_courses_on_course_note", using: :gin
    t.index ["division_description"], name: "index_courses_on_division_description"
    t.index ["term_name"], name: "index_courses_on_term_name"
    t.index ["term_year"], name: "index_courses_on_term_year"
    t.index ["title"], name: "index_courses_on_title", using: :gin
  end

  create_table "division_mappings", id: :serial, force: :cascade do |t|
    t.string "academic_group"
    t.string "subject_description"
    t.string "division"
    t.string "division_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_courses", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.boolean "include_in_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_meeting_pattern_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_instructors", "courses"
  add_foreign_key "course_meeting_patterns", "courses"
  add_foreign_key "course_readings", "courses"
  add_foreign_key "courses", "courses", column: "prereq"
  add_foreign_key "tags", "courses"
  add_foreign_key "tags", "users"
  add_foreign_key "user_courses", "course_meeting_patterns"
  add_foreign_key "user_courses", "courses"
  add_foreign_key "user_courses", "users"
end
