About Curricle
==============

Curricle is a curriculum mapping experiment that serves as an advising tool.

Development
===========

Requirements:
* Ruby 2.4.2
* PostgreSQL 9.6

Setup:

    $ bundle install
    $ cp config/database.yml.example config/database.yml
      (edit database.yml as you wish)
      (ensure PostgreSQL is running)
    $ bundle exec rake db:setup
