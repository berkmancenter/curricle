source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'jbuilder', '~> 2.5'
gem 'pg', '~> 0.21'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '~> 4.0'
gem 'webpacker', '~> 3.0'

group :development, :test do
  gem 'awesome_print', '~> 1.8'
  gem 'pry', '~> 0.11'
  gem 'pry-byebug', '~> 3.5'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 3.7'
  gem 'therubyracer', '~> 0.12'
end

group :development do
  gem 'brakeman', '~> 4.0'
  gem 'drg', '~> 1.5'
  gem 'haml_lint', '~> 0.27'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.51'
  gem 'rubocop-rspec', '~> 1.20'
  gem 'spring', '~> 2.0'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'spring-commands-rubocop', '~> 0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 3.5'
end

group :test do
  gem 'capybara-webkit', '~> 1.14'
  gem 'database_cleaner', '~> 1.6'
  gem 'factory_girl_rails', '~> 4.9'
  gem 'fuubar', '~> 2.2'
  gem 'headless', '~> 2.3'
  gem 'launchy', '~> 2.4'
  gem 'selenium-client', '~> 1.2'
  gem 'selenium-webdriver', '~> 3.8'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.1'
end
