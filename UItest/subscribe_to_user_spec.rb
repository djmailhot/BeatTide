require 'selenium/client'
require 'spec_helper'

def wait_for_ajax(timeout=5000)
  js_condition = 'selenium.browserbot.getCurrentWindow().jQuery.active == 0'
  @selenium_driver.wait_for_condition(js_condition, timeout)
end

describe "Subscribe to User" do
  attr_reader :selenium_driver
  alias :page :selenium_driver

  before(:all) do 
    @verification_errors = []
    
    @selenium_driver = Selenium::Client::Driver.new(
    :host => "localhost",
    :port => 4444,
    :browser => "*firefox",
    :url => "http://localhost:3000/",
    :timeout_in_second => 60)
  end

  before(:each) do
    selenium_driver.start_new_browser_session
    page.open "/"
    page.click 'fb_button', :wait_for => :page
  end

  after(:each) do
    @selenium_driver.close_current_browser_session
  end
  
  it "should allow first user to sign in" do
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    page.text?('Signed in as').should be_true
    wait_for_ajax
  end

  it "should allow a user to subscribe to another user" do
    page.type 'email', 'beatstides@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    page.text?('Signed in as').should be_true
    wait_for_ajax
    page.click 'link=Find Friends'
    wait_for_ajax
    page.type 'user_search_box', 'Beat'
    page.click 'user_search_button'    
    page.click 'link=Beat Tide'
    wait_for_ajax
    page.click 'subscribe'
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
