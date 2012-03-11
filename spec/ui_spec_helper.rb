# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Sign in the given user
  # Author:: Melissa Winstanley
  def test_sign_in(user)
    controller.sign_in(user)
  end

# HELPER METHODS FOR UI TESTING

  # Waits for all ajax requests that are currently happening to cease
  def wait_for_ajax(timeout=5000)
    @selenium_driver.wait_for_condition("selenium.browserbot.getUserWindow().jQuery != 'undefined'", timeout)
    js_condition = 'selenium.browserbot.getUserWindow().jQuery.active == 0'
    @selenium_driver.wait_for_condition(js_condition, timeout)
  end

  # Sets up the browser for testing
  def setup_browser
    @selenium_driver = Selenium::Client::Driver.new(
    :host => "localhost",
    :port => 4444,
    :browser => "*firefox",
    :url => "http://localhost:3000/",
    :timeout_in_second => 60)
    @elements = Selenium::Client::JavascriptExpressionBuilder.new()
  end

  # Signs in a user with an email and password
  def signin_user(email, password)
    page.click 'fb_button', :wait_for => :page
    page.type 'email', email
    page.type 'pass', password
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax    
  end
  
end
