class CoursesController < ApplicationController

  def search
    search = Course.search do
      fulltext params[:keyword]? params[:keyword] : '', :fields => :title
      fulltext params[:keyword]? params[:keyword] : '', :fields => :course_description_long
      with :term_year, 2017
      paginate :page => 1, :per_page => 50
    end    
    @courses = search.results
    render :json => @courses
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

  def events_by_date
    Course.where(:created_at => @selected_date.beginning_of_day..@selected_date.end_of_day)
  end
end
