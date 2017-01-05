class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @matching_courses ||= []
    @course_groups ||= []

    if query_filters.present?
      @keywords = query_filters[:keywords]

      query = Course.left_outer_joins(:course_meeting_patterns).search_for(query_filters)

      term, year = query_filters[:term].split('_')
      query = query.where(term_name: term, term_year: year)

      unless query_filters[:school] == 'all'
        query = query.where(academic_group: query_filters[:school])
      end

      unless query_filters[:department] == 'all'
        query = query.where(class_academic_org_description: query_filters[:department])
      end

      unless query_filters[:subject] == 'all'
        query = query.where(subject_description: query_filters[:subject])
      end

      unless query_filters[:units][:min] == 'any'
        query = query.where("units_maximum >= ?", query_filters[:units][:min])
      end

      unless query_filters[:units][:max] == 'any'
        query = query.where("units_maximum <= ?", query_filters[:units][:max])
      end

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
    end
  end

  def search
    session[:query_filters] = {
      term: params[:term] || '',
      keywords: params[:keywords] || '',
      keyword_options: params[:keyword_options] || [],
      school: params[:school],
      department: params[:department],
      subject: params[:subject],
      units: {
        min: params[:units_min],
        max: params[:units_max]
      },
      times: Course.schedule_filter_map(params)
    }.to_json

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

    if user_course = UserCourse.find_by(user_id: current_user.id, course_id: @course.id)
      user_course.destroy
    end

    respond_to do |format|
      format.html { redirect_to '/' }
      format.js
    end
  end
end
