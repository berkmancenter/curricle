# frozen_string_literal: true

if Rails.env.development?
  # Pull current user from Rails environment and pass its token to API
  GraphiQL::Rails.config.headers['Authorization'] = lambda do |context|
    current_user = context.request.env['warden'].user

    return if current_user.blank?

    "Bearer #{current_user.api_token}"
  end
end
