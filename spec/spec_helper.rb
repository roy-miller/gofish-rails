ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rails/all'
require 'rspec/rails'
require 'capybara/rails'
require 'factory_girl'
require 'database_cleaner'
require 'pry'

#Dir[File.join(File.dirname(__FILE__), "..", "lib" , "**.rb")].each { |f| require f }
#Dir[File.join(File.dirname(__FILE__), "..", "spec/factories" , "**.rb")].each { |f| require f }
$:.unshift File.expand_path '../../app/models', __FILE__

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end
  config.after(:all) do |example|
    DatabaseCleaner.clean
  end
end

# RSpec.configure do |config|
#   config.expect_with :rspec do |expectations|
#     expectations.include_chain_clauses_in_custom_matcher_descriptions = true
#   end
#   config.mock_with :rspec do |mocks|
#     mocks.verify_partial_doubles = true
#   end
# end
