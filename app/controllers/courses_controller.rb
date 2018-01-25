# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :authenticate_user!
  #TODO Clean up after session and token implementation at frontend
  skip_before_action :verify_authenticity_token
  before_action :set_current_user

  # TODO: demo purpose
  def search
    search = Course.search do
      fulltext params[:keyword] ? params[:keyword] : '', fields: :title
      fulltext params[:keyword] ? params[:keyword] : '', fields: :course_description_long
      with :term_year, 2017
      paginate page: 1, per_page: 50
    end
    @courses = search.results
    render json: @courses, methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule]
  end

  def index
    render json: Course.first(50).as_json
  end

  def categories
    filters = []
    filters << { name: 'Department', options: Course.departments, field: 'class_academic_org_description' }
    filters << { name: 'Semester', options: Course.semesters, field: 'term_name' }
    render json: filters.as_json
  end

  def courses_by_day
    term_name = params[:term_name] || current_semester.split(' ').first
    term_year = params[:term_year] || current_semester.split(' ').last
    courses = [
      {
        day: 'Monday',
        courses: Course.courses_by_day_and_term('meets_on_monday', term_name, term_year)
      },
      {
        day: 'Tuesday',
        courses: Course.courses_by_day_and_term('meets_on_tuesday', term_name, term_year)
      },
      {
        day: 'Wednesday',
        courses: Course.courses_by_day_and_term('meets_on_wednesday', term_name, term_year)
      },
      {
        day: 'Thursday',
        courses: Course.courses_by_day_and_term('meets_on_thursday', term_name, term_year)
      },
      {
        day: 'Friday',
        courses: Course.courses_by_day_and_term('meets_on_friday', term_name, term_year)
      }
    ]
    render json: courses
  end

  def fullsearch
    query_filters = {
      term: params[:term],
      keywords: params[:keywords],
      keyword_options: params[:keyword_options] || { "0": [] },
      keyword_weights: params[:keyword_weights],
      school: params[:school],
      department: params[:department],
      subject: params[:subject],
      type: params[:type],
      units: {
        min: params[:units_min],
        max: params[:units_max]
      },
      times: Course.schedule_filter_map(params)
    }

    @nav = :catalog
    @matching_courses ||= []
    @course_groups ||= []
    @user_course_ids = [] # current_user.courses.all.map(&:id)

    if query_filters.present?
      @keyword_filters = build_keyword_filters(query_filters)

      query = sunspot_search(query_filters, :courses)
      @matching_courses = query.results
      @matching_course_ids = @matching_courses.map(&:id)

    else
      @keyword_filters = [{ keywords: '', keyword_options: '' }]
    end
    render json: @matching_courses, methods: %i[meeting_with_tods instructor]
  end

  def clear_search
    session.delete(:query_filters)
    redirect_to '/'
  end

  # add course to current user's tray
  def add_to_tray
    course = Course.find(params["id"])
    user_course = UserCourse.find_or_create_by(user_id: current_user.id, course_id: course.id)
    render json: user_course
  end

  # remove course from current user's tray
  def remove_from_tray
    course = Course.find(params["id"])

    if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: course.id))
      user_course.destroy
    end

    render json: user_course
  end

  # add course meeting pattern to current user's schedule
  def add_to_schedule
    user_course = UserCourse.find_or_initialize_by(
      user_id: current_user.id,
      course_id: params["id"]
    )

    user_course.course_meeting_pattern_id = nil
    user_course.include_in_path = true
    user_course.save

    render json: user_course

  end

  # remove course meeting pattern from current user's schedule
  def remove_from_schedule
    if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: params["id"]))
      user_course.course_meeting_pattern_id = nil
      user_course.include_in_path = false
      user_course.save
    end

    render json: user_course
  end

  # get user's course data
  def user_courses
    tray = current_user.courses.order(created_at: :desc)

    # organize the existing courses into days of the week
    @meeting_patterns_per_day = {
      Monday: current_user.patterns_for_all_courses( by_day: :monday).to_a,
      Tuesday: current_user.patterns_for_all_courses( by_day: :tuesday).to_a,
      Wednesday: current_user.patterns_for_all_courses( by_day: :wednesday).to_a,
      Thursday: current_user.patterns_for_all_courses( by_day: :thursday).to_a,
      Friday: current_user.patterns_for_all_courses( by_day: :friday).to_a
    }

    # organize the existing courses into years/semesters
    @meeting_patterns_per_year = {}

    semester_map.flatten.each do |year|      
      @meeting_patterns_per_year[:"#{year}"] = current_user.patterns_for_all_courses(by_term: year).to_a
    end

    user_courses = {
      :tray => JSON.parse(tray.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule])),
      :semester => JSON.parse(@meeting_patterns_per_day.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule])),
      :multi_year => JSON.parse(@meeting_patterns_per_year.to_json(methods: %i[meeting_with_tods instructor user_tags user_annotations user_schedule]))
    }
    render json: user_courses
  end

  # private

  # # remove course from current user's tray
  # def remove_from_tray
  #   course = Course.find(params["id"])

  #   if (user_course = UserCourse.find_by(user_id: current_user.id, course_id: course.id))
  #     user_course.destroy
  #   end

  #   render json: user_course
  # end
end
