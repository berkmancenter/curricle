# frozen_string_literal: true

# Create a unique composite key for courses
class AddCompositeKeyToCourses < ActiveRecord::Migration[5.2]
  def change
    add_index(
      :courses,
      %i[external_course_id offer_number term_code session_code class_section],
      unique: true,
      name: 'by_unique_composite_key'
    )
  end
end
