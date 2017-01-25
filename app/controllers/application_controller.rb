class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionHelper

  def logout
    unauth
    redirect_to '/'
  end

  private

  def require_auth
    unless authed?
      render nothing: true, status: :unauthorized
    end
  end
end
