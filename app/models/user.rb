# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :annotations, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses, inverse_of: :users

  has_secure_token :api_token
  has_secure_token :schedule_token
end
