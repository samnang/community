ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test_notifier/runner/minitest'
require 'capybara/rails'
require 'support/services'
require 'support/auth'
require 'support/integration'

TestNotifier.silence_no_notifier_warning = true
OmniAuth.config.test_mode                = true

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Support::Integration
  include Support::Auth

  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    mock_uniweb_user({}) 
  end

  teardown do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

