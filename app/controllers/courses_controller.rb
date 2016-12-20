class CoursesController < ApplicationController
  before_action :require_auth
  
  def index
    @matching_courses ||= []
  end

  def search
    @matching_courses = Course.search_for(params["query"])
    @no_matches = @matching_courses.empty?
    render :index
  end
end
