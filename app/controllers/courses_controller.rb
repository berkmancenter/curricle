class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @matching_courses ||= []
    @course_groups ||= []
  end

  def search
    query = Course.search_for(params["query"])

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

    render :index
  end
end
