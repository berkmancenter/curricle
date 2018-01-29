# frozen_string_literal: true

# Stores annotation text added by users for courses
class Annotation < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :text, presence: true
end
