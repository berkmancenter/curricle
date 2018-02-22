# frozen_string_literal: true

class CoursesController < ApplicationController
  # TODO: Clean up after session and token implementation at frontend
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  # add course to current user's tray
  def add_to_tray
    course = Course.find(params['id'])
    user_course = UserCourse.find_or_create_by(user_id: current_user.id, course_id: course.id)
    render json: user_course
  end

  # remove course from current user's tray
  def remove_from_tray
    course = Course.find(params['id'])

    if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: course.id))
      user_course.destroy
    end

    render json: user_course
  end

  # add course meeting pattern to current user's schedule
  def add_to_schedule
    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: params['id']
    )

    user_course.course_meeting_pattern_id = nil
    user_course.include_in_path = true
    user_course.save

    render json: user_course
  end

  # remove course meeting pattern from current user's schedule
  def remove_from_schedule
    if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: params['id']))
      user_course.course_meeting_pattern_id = nil
      user_course.include_in_path = false
      user_course.save
    end

    render json: user_course
  end

  # get user's course data
  def user_courses
    user = User.current

    return if user.blank?

    tray = user.courses.order(created_at: :desc)

    # organize the existing courses into days of the week
    @meeting_patterns_per_day = {
      Monday: user.patterns_for_all_courses(by_day: :monday).to_a,
      Tuesday: user.patterns_for_all_courses(by_day: :tuesday).to_a,
      Wednesday: user.patterns_for_all_courses(by_day: :wednesday).to_a,
      Thursday: user.patterns_for_all_courses(by_day: :thursday).to_a,
      Friday: user.patterns_for_all_courses(by_day: :friday).to_a
    }

    # organize the existing courses into years/semesters
    @meeting_patterns_per_year = {}

    semester_map.flatten.each do |year|
      @meeting_patterns_per_year[:"#{year}"] = user.patterns_for_all_courses(by_term: year).to_a
    end

    user_courses = {
      tray: JSON.parse(tray.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule])),
      semester: JSON.parse(@meeting_patterns_per_day.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule])),
      multi_year: JSON.parse(@meeting_patterns_per_year.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule]))
    }
    render json: user_courses
  end

  private

  def set_current_user
    User.current =
      if params[:schedule_token]
        User.find_by(schedule_token: params[:schedule_token])
      else
        current_user
      end
  end
end
