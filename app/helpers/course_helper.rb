module CourseHelper
  def classes_for_course(course)
    classes = []

    classes << 'matched' if @matching_course_ids.include?(course.id)
    classes << 'green' # TODO: figure out what to base colors on
    classes << 'added' if @user_course_ids.include?(course.id)

    classes.compact.join(' ')
  end

  def hover_info(course)
    course.subject + " " + course.catalog_number.to_s
  end
end
