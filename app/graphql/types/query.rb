# frozen_string_literal: true

module Types
  class Query < Types::BaseObject
    description 'Curricle queries'

    field :course, Types::CourseType, description: 'Find a course', null: true do
      argument :id, ID, 'Course ID', required: true
    end

    def course(id:)
      Course.find(id)
    end

    field :course_counts, [Types::CourseCountType], null: false, description: 'Returns aggregate data about the number of courses for given criteria' do
      argument :basic, String, 'Simple search queries using the my.harvard operators', required: false
      argument :component, Types::Enums::Component, required: false
      argument :course_levels, [Types::Enums::CourseLevel], required: false
      argument :department, Types::Enums::Department, required: false
      argument :filtered, Boolean, required: false
      argument :semester, Types::Inputs::Semester, required: false
      argument :semester_range, Types::Inputs::SemesterRange, required: false
    end

    def course_counts(**args)
      Resolvers::CourseCounts.run(args)
    end

    field :courses_connected_by_instructor, [Types::CourseType], null: false, description: 'Returns collection of courses taught by instructors connected to a given instructor' do
      argument :course_levels, [Types::Enums::CourseLevel], required: false
      argument :name, String, "Instructor's name", required: true
      argument :semester, Types::Inputs::Semester, required: false
      argument :semester_range, Types::Inputs::SemesterRange, required: false
    end

    def courses_connected_by_instructor(**args)
      name = args[:name]

      return Course.none if name.blank?

      Resolvers::CoursesConnectedByInstructor.run(
        course_levels: args[:course_levels] || [],
        name: name,
        semester_range: args[:semester_range] || { start: args[:semester] }
      )
    end

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
  end
end
