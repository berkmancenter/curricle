# frozen_string_literal: true

module Types
  class Query < Types::BaseObject
    description 'Curricle queries'

    field :course, Types::CourseType, description: 'Find a course', null: true do
      argument :id, ID, 'Course ID', required: true
    end

    field :course_counts,
          description: 'Return course counts',
          resolver: Resolvers::CourseCounts

    field :courses_connected_by_instructor,
          description: 'Returns collection of courses taught by instructors connected to a given instructor',
          resolver: Resolvers::CoursesConnectedByInstructor

    field :courses_connection,
          description: 'Queries that return lists of courses with connection metadata',
          resolver: Resolvers::CoursesConnection

    field :instructor_names, [String], null: false, description: 'Returns a collection of instructor names for a given range of years' do
      argument :semester, Types::Inputs::Semester, required: true
      argument :past_years, Integer, 'Include instructors for this number of past years', required: false
    end

    def instructor_names(semester:, past_years: 0)
      Resolvers::InstructorNames.run(semester: semester, past_years: past_years)
    end

    field :user_courses, [Types::UserCourseType], null: false, description: "Return user's selected courses" do
      argument :schedule_token, String, 'Token for looking up a shared schedule', required: false
    end

    def user_courses(schedule_token: nil)
      Resolvers::UserCourses.run(current_user: context[:current_user], schedule_token: schedule_token)
    end

    def course(id:)
      Course.find(id)
    end
  end
end
