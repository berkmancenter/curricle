module SessionHelper
  # Returns the currently authed user (if any)
  def current_user
    return @current_user if @current_user.present?
    return nil if session['cas'].blank? || session['cas']['user'].blank?

    # TODO: probably want to refactor this once we see what `extra_attributes` HarvardKey gives back
    # as part of the `cas` session object, but for now we'll simply create a new user if the external_user_id doesn't exist
    @current_user = User.find_or_create_by(external_user_id: session['cas']['user'])
  end

  # Unauths the current user
  def unauth
    session.delete('cas')
    session.delete(:query_filters)
    session.delete(:generate_filters)
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

  # retrieves the most recent recommendation filters submitted by the user
  def generate_filters
    @generate_filters ||= (session[:generate_filters] || {}).deep_symbolize_keys
  end

  def filter_option_state(query_filters, option, value)
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
               when :units_total
                 query_filters[:units_total].to_s == value.to_s
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
