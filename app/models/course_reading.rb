class CourseReading < ApplicationRecord
  belongs_to :course

  searchable do
    integer :external_course_id
    integer :external_citation_id
    integer :course_id, references: Course
    text :title
    text :author_last_name
    text :author_first_name
    string :url
    text :annotation
  end

  def author_full_name
    "#{first_name} #{last_name}"
  end
end
