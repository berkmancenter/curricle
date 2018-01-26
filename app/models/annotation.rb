# frozen_string_literal: true

class Annotation < ApplicationRecord
  belongs_to :user
  belongs_to :course
end
