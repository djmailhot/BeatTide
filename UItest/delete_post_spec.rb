require 'selenium/client'
require 'ui_spec_helper'

# UI automation testing for the user creation and deletion of posts.
#
# Author: Brett Webber
describe "Deleting a Post" do
  attr_reader :selenium_driver
  alias :page :selenium_driver
    
  # Sets up the browser for the UI testing
  before(:all) do 
    setup_browser
  end

  # Starts up the browser and logs in the user
  before(:each) do
    selenium_driver.start_new_browser_session
    page.open "/"
    page.text?('Hello, music lover!').should be_true
    page.click 'fb_button', :wait_for => :page
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true
  end

  # Closes down the browser
  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  # 
  it "should not allow user to access tutorial before signing in" do
    page.click 'link=Tutorial'
    wait_for_ajax
    page.text?('Adding a Song').should be_true
  end

  it "should not allow user to access about before signing in" do
    page.click 'link=About'
    wait_for_ajax
    page.text?('Development Team').should be_true
  end
end
