require 'spinach-rails'
ENV['RAILS_ENV'] = 'test'
require './config/environment'

require 'rspec/rails'
require 'minitest/spec'
require 'database_cleaner'
require 'capybara'
require 'factory_girl'
require 'spinach/capybara'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'pry'

# disables ActiveRecord logging (set to 0 or comment to turn it back on)
ActiveRecord::Base.logger.level = 1

# disables rack logging
module Rack
 class CommonLogger
   def call(env)
     # do nothing
     @app.call(env)
   end
 end
end

# disables poltergeist logging
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    extensions: [ 'features/support/logs.js' ],
    js_errors:   true
  )
end

Capybara.javascript_driver = :poltergeist
Spinach::FeatureSteps.include Spinach::FeatureSteps::Capybara
Spinach.hooks.on_tag('javascript') { ::Capybara.current_driver = ::Capybara.javascript_driver }
Spinach.config[:failure_exceptions] << RSpec::Expectations::ExpectationNotMetError
Spinach::FeatureSteps.include RSpec::Matchers
Spinach::FeatureSteps.include FactoryGirl::Syntax::Methods

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :deletion

Spinach.hooks.before_run do
  FactoryGirl.reload # TODO why?
end

Spinach.hooks.before_scenario do |scenario|
  DatabaseCleaner.start
end

Spinach.hooks.after_scenario do |scenario|
  DatabaseCleaner.clean
end

#DatabaseCleaner.strategy = :deletion
#Spinach.hooks.before_scenario{ DatabaseCleaner.clean }
#Spinach.config.save_and_open_page_on_failure = true
