class PathController < ApplicationController
  before_action :require_auth

  def index
    # TODO: scope this to only courses for the selected semester
    @meeting_patterns = current_user.patterns_for_all_courses
    @meeting_patterns_per_day = {
      monday: current_user.patterns_for_all_courses(:monday),
      tuesday: current_user.patterns_for_all_courses(:tuesday),
      wednesday: current_user.patterns_for_all_courses(:wednesday),
      thursday: current_user.patterns_for_all_courses(:thursday),
      friday: current_user.patterns_for_all_courses(:friday)
    }
  end

  # add course meeting pattern to current user's path
  def add
    @pattern = CourseMeetingPattern.find(params[:pattern_id])

    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: @pattern.course_id,
      course_meeting_pattern_id: [nil, @pattern.id]
    )

    user_course.course_meeting_pattern_id = @pattern.id
    user_course.include_in_path = true
    user_course.save

    respond_to do |format|
      format.html { redirect_to '/path' }
      format.js
    end
  end

  # remove course meeting pattern from current user's path
  def remove
    @pattern = CourseMeetingPattern.find(params[:pattern_id])

    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: @pattern.course_id,
    )

    if user_course = UserCourse.find_by(user_id: current_user.id, course_meeting_pattern_id: @pattern.id)
      user_course.course_meeting_pattern_id = nil
      user_course.include_in_path = false
      user_course.save
    end

    respond_to do |format|
      format.html { redirect_to '/path' }
      format.js
    end
  end
end
