# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :authenticate_user!
  # TODO: Clean up after session and token implementation at frontend
  skip_before_action :verify_authenticity_token

  # add tag to user's course in tray
  def create
    tag_name = params['name'].strip.downcase
    course = Course.find(params['course_id'])
    new_tag = Tag.find_or_create_by(user_id: current_user.id, course_id: course.id, name: tag_name)
    render json: new_tag
  end

  # remove tag from user's course in tray
  def remove
    tag_name = params['name'].strip.downcase
    course = Course.find(params['course_id'])
    if (tag = Tag.find_by(user_id: current_user.id, course_id: course.id, name: tag_name))
      tag.destroy
    end

    render json: tag
  end

  # search for tag suggestions
  def search
    tag_name = params['name'].strip.downcase
    tags = Tag.where('name LIKE ?', "%#{tag_name}%").pluck(:name)

    render json: tags
  end

  # find course's tags for current user
  def get_tags
    course = Course.find(params['course_id'])
    tags = Tag.where(user_id: current_user.id, course_id: course.id)

    render json: tags
  end
end
