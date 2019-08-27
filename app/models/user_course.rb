# frozen_string_literal: true

class UserCourse < ApplicationRecord
  belongs_to :user, primary_key: :huid
  belongs_to :course
end
