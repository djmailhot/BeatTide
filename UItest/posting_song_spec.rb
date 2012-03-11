require 'selenium/client'
require 'ui_spec_helper'

# UI automation testing for a user posting a song.  
#
# Author: Brett Webber
describe "UI for Song Posting" do
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
    page.element?('welcome').should be_true
    page.click 'fb_button', :wait_for => :page
    page.type 'email', 'beatertider@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true
  end

  # Closes down the browser  
  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  # Walkthrough where the user tries to post a song to their feed.
  it "should allow user to post a song" do
    page.type 'song_search_box', 'Friday'
    page.click 'song_search_button'
    wait_for_ajax
    page.click 'css=button.add_button'
    wait_for_ajax
    @elements.find_element('message_container').should_not be_nil
    @elements.find_element('29480889').should_not be_nil    
  end
end
