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
  has_many :user_courses, dependent: :destroy, primary_key: :huid
  has_many :courses, through: :user_courses, inverse_of: :users

  has_secure_token :api_token
  has_secure_token :schedule_token

  before_validation do
    return unless ENV['AUTHENTICATION_SCHEME'] == 'DATABASE'

    self.huid = username
  end

  # populate attributes with data returned by CAS
  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :displayName
        self.display_name = value
      when :givenName
        self.given_name = value
      when :harvardEduIdNumber
        self.huid = value
      when :mail
        self.email = value
      when :sn
        self.surname = value
      end
    end
  end
end
