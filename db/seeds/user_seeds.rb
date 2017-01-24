User.find_or_create_by(
  external_user_id: 'testperson',
  email: 'user@harvard.edu',
  first_name: 'Test',
  last_name: 'Person',
  major: 'Computer Science'
)
