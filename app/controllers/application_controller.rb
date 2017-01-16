class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionHelper

  private

  def require_auth
    unless authed?
      # TODO: redirect to login url once we know what that is
    end
  end
end
