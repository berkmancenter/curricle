# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :course_meeting_patterns, dependent: :destroy
  has_many :course_instructors, dependent: :destroy
  has_many :course_readings, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses, inverse_of: :courses
  has_many :annotations, dependent: :destroy

  searchable do
    integer :id
    integer :external_course_id
    text :title, boost: 5

    # Need text version of title for searching and string version for sorting
    string :title_sortable do
      title
    end

    string :term_name
    integer :term_year
    integer :academic_year
    string :class_section
    string :component
    integer :prereq
    string :subject
    text :subject_description
    string :subject_description
    text :subject_academic_org_description
    string :subject_academic_org_description
    text :academic_group
    string :academic_group
    text :academic_group_description
    text :grading_basis_description
    string :term_pattern_code
    text :term_pattern_description
    integer :units_maximum
    string :catalog_number
    text :course_description
    text :course_description_long
    text :course_note
    text :class_academic_org_description
    string :class_academic_org_description
    join(:class_meeting_number, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:meeting_time_start, target: CourseMeetingPattern, type: :integer, join: { from: :course_id, to: :id })
    join(:meeting_time_end, target: CourseMeetingPattern, type: :integer, join: { from: :course_id, to: :id })
    join(:meets_on_monday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_tuesday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_wednesday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_thursday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_friday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_saturday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:meets_on_sunday, target: CourseMeetingPattern, type: :boolean, join: { from: :course_id, to: :id })
    join(:start_date, target: CourseMeetingPattern, type: :date, join: { from: :course_id, to: :id })
    join(:end_date, target: CourseMeetingPattern, type: :date, join: { from: :course_id, to: :id })
    join(:external_facility_id, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:facility_description, target: CourseMeetingPattern, type: :string, join: { from: :course_id, to: :id })
    join(:first_name, target: CourseInstructor, type: :text, join: { from: :course_id, to: :id })
    join(:last_name, target: CourseInstructor, type: :text, join: { from: :course_id, to: :id })
    join(:title, prefix: 'reading', target: CourseReading, type: :text, join: { from: :course_id, to: :id })
    join(:author_first_name, target: CourseReading, type: :text, join: { from: :course_id, to: :id })
    join(:author_last_name, target: CourseReading, type: :text, join: { from: :course_id, to: :id })
  end

  scope :return_as_relation, ->(search_results) do
    matching_item_ids = search_results.hits.map(&:primary_key)
    where id: matching_item_ids
  end

  before_save :set_division

  def set_division
    mapping = DivisionMapping.find_by(
      academic_group: academic_group,
      subject_description: subject_description
    )

    # if we didn't find a mapping, search for one without an academic_group
    if mapping.blank?
      mapping = DivisionMapping.find_by(
        academic_group: nil,
        subject_description: subject_description
      )
    end

    if mapping.blank?
      self.division = 'misc'
      self.division_description = 'Misc'
    else
      self.division = mapping.division
      self.division_description = mapping.division_description
    end
  end

  def set_division!
    set_division
    save
  end

  def user_tags
    tags.where(
      user_id: User.current
    )
  end
end
