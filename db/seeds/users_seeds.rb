user = User.new(
  {
    :email => "testuser@endpoint.com",
    :password => "testuser",
    :password_confirmation => "testuser" 
  }
).save
if user.nil?
	puts "*** Added #{user.try(:email)}  ***"
else
	puts "*** User already exits ***"
end
