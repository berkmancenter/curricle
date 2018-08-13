# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :name, presence: true
end
