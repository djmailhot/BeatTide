require 'selenium/client'
require 'ui_spec_helper'


# UI automation testing for the user editing their profile.
#
# Author: Brett Webber
describe "UI for Editing Profile" do
  attr_reader :selenium_driver
  alias :page :selenium_driver

  # Sets up the browser for the UI testing  
  before(:all) do     
    @selenium_driver = Selenium::Client::Driver.new(
    :host => "localhost",
    :port => 4444,
    :browser => "*firefox",
    :url => "http://localhost:3000/",
    :timeout_in_second => 60)
  end

  # Starts up the browser and logs in the user  
  before(:each) do
    selenium_driver.start_new_browser_session
    page.open "/"
    page.click 'fb_button', :wait_for => :page
    page.type 'email', 'beatertider@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
  end

  # Closes down the browser  
  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  # Tries to edit the username of a user, and checks to see if the
  # username is successfully changed.
  it "should allow user to edit their page" do
    wait_for_ajax
    page.click 'css=#edit_profile a'
    wait_for_ajax
    page.text?('Edit Your Profile').should be_true
    page.type 'user_username', 'bleh'
    page.click 'css=input[name="commit"]'
    page.click 'css=#signed_in_as a'
    wait_for_ajax
    page.text?('bleh').should be_true
    
    page.click 'css=#edit_profile a'
    wait_for_ajax
    page.text?('Edit Your Profile').should be_true
    page.type 'user_username', 'rebeccablack'
    page.click 'css=input[name="commit"]'
    page.click 'css=#signed_in_as a'
    page.text?('rebeccablack').should be_true
  end
end
