# frozen_string_literal: true

user = User.new(
  email: 'testuser@endpoint.com',
  password: 'testuser',
  password_confirmation: 'testuser',
  huid: '99999999',
  username: '99999999'
)

result =
  if user.save
    "Added #{user.email}"
  else
    "Could not create user: #{user.errors.full_messages.join(', ')}"
  end

puts "*** #{result} ***"
