class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @matching_courses ||= []
    @course_groups ||= []

    if @keywords = session[:keywords]
      query = Course.search_for(@keywords)

      @course_groups = []

      Course.subjects(query).each do |subject|
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
    session[:keywords] = params["keywords"]
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
