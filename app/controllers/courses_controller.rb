class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @nav = :catalog
    @matching_courses ||= []
    @course_groups ||= []
    @keyword_filters ||= []

    if query_filters.present?
      query_filters[:keywords].each do |key, value|
        next if value.blank?
        @keyword_filters << {
          keywords: value,
          keyword_options: query_filters[:keyword_options][key]
        }
      end

      @keyword_filters << { keywords: '', keyword_options: {} } if @keyword_filters.blank?
      keyword_filters = @keyword_filters.deep_dup
      query = Course.left_outer_joins(:course_meeting_patterns).search_for(keyword_filters.shift)
      keyword_filters.each do |filter|
        query = query.search_for(filter)
      end

      query = apply_common_filters(query, query_filters)

      query_filters[:times].each do |day, values|
        unless values[:min] == 'any'
          query = query.where.not("course_meeting_patterns.meets_on_#{day} = ? AND EXTRACT(HOUR from meeting_time_start) < ?", true, values[:min])
        end

        unless values[:max] == 'any'
          query = query.where.not("course_meeting_patterns.meets_on_#{day} = ? AND EXTRACT(HOUR from meeting_time_start) > ?", true, values[:max])
        end
      end

      @course_groups = []

      Course.subject_groups(query).each do |subject|
        group = {
          subject: subject,
          days: [
            { name: 'Mon', courses: Course.for_day(:monday, subject_academic_org_description: subject) },
            { name: 'Tue', courses: Course.for_day(:tuesday, subject_academic_org_description: subject) },
            { name: 'Wed', courses: Course.for_day(:wednesday, subject_academic_org_description: subject) },
            { name: 'Thu', courses: Course.for_day(:thursday, subject_academic_org_description: subject) },
            { name: 'Fri', courses: Course.for_day(:friday, subject_academic_org_description: subject) },
          ]
        }

        not_empty = group[:days].find { |day| !day[:courses].empty? }
        @course_groups << group if not_empty
      end

      @matching_courses = query.all
    else
      @keyword_filters << { keywords: '', keyword_options: '' }
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
    }.to_json

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
