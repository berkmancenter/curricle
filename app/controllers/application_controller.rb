# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionHelper

  def set_current_user
    User.current = current_user
  end
end
