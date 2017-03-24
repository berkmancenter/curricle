class CourseReading < ApplicationRecord
  belongs_to :course

  searchable do
    integer :external_course_id
    integer :external_citation_id
    integer :course_id, references: Course
    string :title
    string :author_last_name
    string :author_first_name
    string :url
    text :annotation
  end

  def author_full_name
    "#{first_name} #{last_name}"
  end
end
