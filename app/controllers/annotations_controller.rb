# frozen_string_literal: true

class AnnotationsController < ApplicationController
  before_action :authenticate_user!
  # TODO: Clean up after session and token implementation at frontend
  skip_before_action :verify_authenticity_token

  # add annotation to user's course in tray
  def create
    annotation_data = params['annotation'].strip
    course = Course.find(params['course_id'])
    new_annotation = Annotation.find_or_create_by(user_id: current_user.id, course_id: course.id)
    new_annotation.annotation = annotation_data
    new_annotation.save
    render json: new_annotation
  end

  # find course's annotations for current user
  def get_annotations
    course = Course.find(params['course_id'])
    # For Now always having 1 annotations
    annotations = Annotation.where(user_id: current_user.id, course_id: course.id).first

    render json: annotations
  end
end
