# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :authenticate_user!

  # TODO: demo purpose
  def search
    search = Course.search do
      fulltext params[:keyword] ? params[:keyword] : '', fields: :title
      fulltext params[:keyword] ? params[:keyword] : '', fields: :course_description_long
      with :term_year, 2017
      paginate page: 1, per_page: 50
    end
    @courses = search.results
    render json: @courses
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

  def events_by_date
    Course.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
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
    render json: @matching_courses, methods: %i[meeting instructor]
  end

  def clear_search
    session.delete(:query_filters)
    redirect_to '/'
  end
end
