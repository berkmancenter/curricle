# frozen_string_literal: true

module Resolvers
  # Return a collection of courses that the user has selected
  class UserCoursesResolver
    def call(_obj, args, ctx)
      user =
        if args[:schedule_token].present?
          User.find_by(schedule_token: args[:schedule_token])
        else
          ctx[:current_user]
        end

      return Course.none if user.blank?

      user.courses
    end
  end
end
