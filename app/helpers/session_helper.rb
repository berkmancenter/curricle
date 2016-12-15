module SessionHelper
  # Returns the currently authed user (if any)
  def current_user
    # just return the first user for now, later we'll use the session check below
    return @current_user ||= User.first

    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Auths the provided user
  def auth(user)
    session[:user_id] = user.id
  end

  # Unauths the current user
  def unauth
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns true if user is authed, false otherwise
  def authed?
    current_user.present?
  end
end
