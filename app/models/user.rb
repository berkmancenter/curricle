# frozen_string_literal: true

# Model for storing user records, authenticating against either Harvard Key (CAS) or
# a traditional database
class User < ApplicationRecord
  if ENV['AUTHENTICATION_SCHEME'] == 'CAS'
    devise :cas_authenticatable, :rememberable, :trackable
  else
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable
  end

  has_many :annotations, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses, inverse_of: :users

  has_secure_token :api_token
  has_secure_token :schedule_token

  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      # populate attributes with data returned by CAS here
    end
  end
end
