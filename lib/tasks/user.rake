# frozen_string_literal: true

namespace :users do
  desc 'Seed users model)'
  task reseed: :environment do
    ActiveRecord::Base.transaction do
      require_relative '../../db/seeds/users_seeds'
    end
  end
end
