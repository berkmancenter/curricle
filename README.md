## About Curricle

Curricle is a curriculum mapping experiment that serves as an advising tool.

## Development

Curricle uses a Rails 5.1 backend running in API mode to serve a GraphQL API and a Vue.js 2 single-page application (via the [webpacker](https://github.com/rails/webpacker) gem).

### Requirements
* Ruby 2.3.6
* PostgreSQL 9.6
* Node.js 8.9.4
* Yarn 1.3.2
* Java 8 Runtime Environment (for Solr search engine)

### Installation
1. Install Ruby dependencies:
    * `bundle install`

1. Install JavaScript dependencies:
    * `yarn install`

1. Build Vue.js application:
    * `bin/webpack`

1. Set up host-specific configuration files and edit as needed:
    * `cp config/database.yml.example config/database.yml`
    * `cp config/puma.rb.example config/puma.rb`
    * `cp config/sunspot.yml.example config/sunspot.yml`
    * `cp config/webpacker.yml.example config/webpacker.yml`

1. Place seed files in filesystem:
   * Obtain these files and place them in `lib/seeds/`:
      * `courses.csv`
      * `course_meeting_patterns.csv`
      * `course_instructors.csv`
      * `divisionMappings.csv`

1. Start Solr search engine:
   * `bin/rails sunspot:solr:start`

1. Create databases and populate with seed data:
    * `bin/rails db:setup`
    
1. Create the initial Solr search index:
    * `bin/rails sunspot:reindex`

1. Start Rails application server:
    * `bin/rails s`
