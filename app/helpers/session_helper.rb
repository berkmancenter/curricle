# frozen_string_literal: true

module SessionHelper
  # retrieves the most recent search filters submitted by the user
  def query_filters
    @query_filters ||= (session[:query_filters] || {}).deep_symbolize_keys
  rescue JSON::ParserError
    @query_filters = {}
  end

  # retrieves the most recent recommendation filters submitted by the user
  def generate_filters
    @generate_filters ||= (session[:generate_filters] || {}).deep_symbolize_keys
  end

  def build_keyword_filters(filters)
    filter_set = []
    filters[:keywords].each do |key, value|
      next if value.blank?

      filter_set << {
        keywords: value,
        keyword_options: filters[:keyword_options][key],
        keyword_weights: filters[:keyword_weights][key]
      }
    end

    filter_set.presence || [{ keywords: '', keyword_options: {} }]
  end

  def filter_option_state(query_filters, option, value)
    selected = case option
               when :term
                 query_filters[:term].to_s == value.to_s
               when :keyword_option
                 if query_filters[:keyword_options].blank?
                   %w[title description].include?(value.to_s)
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
               when /units_(min|max|total)/
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
    selected ? 'selected' : false
  end
end
