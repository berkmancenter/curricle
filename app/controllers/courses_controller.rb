class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @nav = :catalog
    @matching_courses ||= []
    @course_groups ||= []

    if query_filters.present?
      @keyword_filters = build_keyword_filters(query_filters)
      keyword_filters = @keyword_filters.deep_dup

      query = sunspot_search(query_filters, :courses)

      @course_groups = []
      Course.groups(query).each do |group|
        group = {
          group: group,
          days: [
            { name: 'Mon', courses: Course.for_day(:monday, division_description: group) },
            { name: 'Tue', courses: Course.for_day(:tuesday, division_description: group) },
            { name: 'Wed', courses: Course.for_day(:wednesday, division_description: group) },
            { name: 'Thu', courses: Course.for_day(:thursday, division_description: group) },
            { name: 'Fri', courses: Course.for_day(:friday, division_description: group) },
          ]
        }

        not_empty = group[:days].find { |day| !day[:courses].empty? }
        @course_groups << group if not_empty
      end
      
      @matching_courses = query.all
    else
      @keyword_filters = [{ keywords: '', keyword_options: '' }]
    end
  end

  def search
    session[:query_filters] = {
      term: params[:term],
      keywords: params[:keywords],
      keyword_options: params[:keyword_options] || { "0": [] },
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

    redirect_to '/'
  end

  def clear_search
    session.delete(:query_filters)
    redirect_to '/'
  end

  def add_to_tray
    @course = Course.find(params["id"])

    UserCourse.find_or_create_by(user_id: current_user.id, course_id: @course.id)

    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end

  def remove_from_tray
    @course = Course.find(params["id"])
    @pattern = CourseMeetingPattern.find_by(id: params["pattern_id"])

    if user_course = UserCourse.find_by(user_id: current_user.id, course_id: @course.id)
      user_course.destroy
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end
end
