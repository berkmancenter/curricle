module CourseHelper
  def classes_for_course(course)
    classes = []

    classes << 'matched' if @matching_courses.include?(course)
    classes << 'green' # TODO: figure out what to base colors on
    classes << 'added' if current_user.added?(course.id)

    classes.compact.join(' ')
  end

  def hover_info(course)
    course.subject + " " + course.catalog_number.to_s
  end  
end
