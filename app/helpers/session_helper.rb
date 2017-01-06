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

  # retrieves the most recent search filters submitted by the user
  def query_filters
    @query_filters ||= JSON.parse(session[:query_filters] || "{}").deep_symbolize_keys
  rescue JSON::ParserError
    @query_filters = {}
  end

  def filter_option_state(option, value)
    query_filters = @query_filters || {}

    selected = case option
               when :term
                 query_filters[:term].to_s == value.to_s
               when :keyword_option
                 if query_filters[:keyword_options].blank?
                   %w(title description).include?(value.to_s)
                 else
                   Array(query_filters[:keyword_options]).include?(value.to_s)
                 end
               when :school
                 query_filters[:school].to_s == value.to_s
               when :department
                 query_filters[:department].to_s == value.to_s
               when :subject
                 query_filters[:subject].to_s == value.to_s
               when :type
                 query_filters[:type].to_s == value.to_s
               when /units_(min|max)/
                 if query_filters[:units].present?
                   query_filters[:units][option.to_s.sub('units_', '').to_sym].to_s == value.to_s
                 end
               when /day_min/
                 if query_filters[:times].present?
                   query_filters[:times][option.to_s.sub('_min', '').to_sym][:min].to_s == value.to_s
                 end
               when /day_max/
                 if query_filters[:times].present?
                   query_filters[:times][option.to_s.sub('_max', '').to_sym][:max].to_s == value.to_s
                 end
               else false
               end
    selected ? "selected" : false
  end
end
