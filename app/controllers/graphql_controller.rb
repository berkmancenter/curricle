# frozen_string_literal: true

class GraphqlController < ApplicationController
  # TODO: investigate CSRF issues in development
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user_with_token

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user
    }

    result = CurricleSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def authenticate_user_with_token
    api_token = request.headers['Authorization']

    # TODO: prevent anonymous API access?
    # render json: { status: 'unauthorized' }, status: :unauthorized if api_token.blank?

    return if api_token.blank?

    user = User.find_by(api_token: api_token.split[1])

    return if user.blank?

    sign_in(:user, user)
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: { error: { message: err.message, backtrace: err.backtrace }, data: {} }, status: 500
  end
end
