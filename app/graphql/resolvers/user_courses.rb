module Resolvers
  # Return a collection of courses that the user has selected
  class UserCourses
    def self.run(current_user:, schedule_token: nil)
      user =
        if schedule_token.present?
          User.find_by(schedule_token: schedule_token)
        else
          current_user
        end

      return Course.none if user.blank?

      user.courses
    end
  end
end
