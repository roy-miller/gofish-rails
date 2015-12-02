ENV['RAILS_ENV'] ||= 'test'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# adjusted order per https://github.com/burke/zeus/issues/474#issuecomment-67864147
require 'rspec/rails'
require 'spec_helper'

# added per http://stackoverflow.com/questions/20614213/how-to-include-a-support-file-in-rails-4-for-rspec
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
