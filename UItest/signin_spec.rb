require "selenium/client"
require 'ui_spec_helper'

# UI automation testing for the user signing in and out.  Also tests
# to make sure that the user can access the tutorial, faq, and about
# pages.
#
# Author: Brett Webber
describe "UI for Signin Page" do
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
    @elements = Selenium::Client::JavascriptExpressionBuilder.new()
  end

  # Starts up the browser and logs in the user  
  before(:each) do
    selenium_driver.start_new_browser_session
    page.open "/"
    page.element?('welcome').should be_true
  end

  # Closes down the browser  
  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  # This walkthrough tries to log in a user and ensures that the user
  # is signed in, then tries to sign out the user and ensures that
  # they are signed out
  it "should accept valid login" do
    page.click 'fb_button', :wait_for => :page
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true
    page.click 'css=#sign_out a', :wait_for => :page
    page.element?('welcome').should be_true
  end

  # Attempts to access the Frequently Asked Questions page without
  # being signed in
  it "should allow user to access FAQ before signing in by clicking the link" do
    page.click 'link=FAQ'
    wait_for_ajax
    page.element?('welcome').should_not be_true
    @elements.find_element('css=#user_header h2').element_value_is('Tutorial').should be_true
  end

  # Attempts to access the Tutorial page without being signed in
  it "should not allow user to access tutorial before signing in" do
    page.click 'link=Tutorial'
    wait_for_ajax
    @elements.find_element('css=#user_headerh2').element_value_is('Frequently Asked Questions').should be_true
  end

  # Attempts to access the About page without being signed in
  it "should not allow user to access about before signing in" do
    page.click 'link=About'
    wait_for_ajax
    page.text?('Development Team').should be_true
    @elements.find_element('css=#user_headerh2').element_value_is('About BeatTide').should be_true
  end
end
