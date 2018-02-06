# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_courses
  has_many :courses, through: :user_courses
  has_many :path_meeting_patterns, through: :user_courses, source: :course_meeting_pattern

  has_secure_token :api_token
  has_secure_token :schedule_token

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def added?(course_id)
    courses.find_by(id: course_id)
  end

  def in_path?(pattern_id)
    user_courses.find_by(
      include_in_path: true,
      course_meeting_pattern_id: pattern_id
    )
  end

  def patterns_for_all_courses(by_day: nil, by_term: nil)
    query = courses.includes(:course_meeting_patterns)

    query = query.where("course_meeting_patterns.meets_on_#{by_day}": true) if by_day.present?

    if by_term.present?
      name, year = by_term.split(/[_\s]/)
      query = query.where(term_name: name, term_year: year)
    end

    query
  end
end
