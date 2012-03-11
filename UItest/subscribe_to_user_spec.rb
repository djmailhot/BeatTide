require 'selenium/client'
require 'ui_spec_helper'

# UI automation testing for one user subscribing to another user.  
#
# Author: Brett Webber
describe "UI for User Subscription" do
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
  end

  # Closes down the browser  
  after(:each) do
    @selenium_driver.close_current_browser_session
  end
  
  # Signs in the first user that is going to be subscribed to to
  # ensure that they are in the sites database.
  it "should allow first user to sign in" do
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true
  end

  # This walkthrough signs in another user and tries to subscribe them
  # to the other if they are subscribed.  If they are already
  # subscribed, also tries to unsubscribe them.
  it "should allow a user to subscribe to another user" do
    page.type 'email', 'beatstides@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true
    wait_for_ajax
    page.click 'link=Find Friends'
    wait_for_ajax
    page.type 'user_search_box', 'Beat'
    page.click 'user_search_button'
    wait_for_ajax
    page.click 'link=Beat Tide'
    wait_for_ajax
    if page.text?('Subscribe')
      page.click 'subscribe'
      wait_for_ajax
      page.text?('Subscribed to').should be_true
    else 
      page.click 'subscribe'
      wait_for_ajax
      page.text?('Unsubscribed from').should be_true
    end
  end
end
