require "selenium/client"
require 'spec_helper'

def wait_for_ajax(timeout=5000)
  js_condition = 'selenium.browserbot.getCurrentWindow().jQuery.active == 0'
  @selenium_driver.wait_for_condition(js_condition, timeout)
end

describe "Song posting" do
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
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page #:wait_for_element_present => 'id=song_search_box'
  end

  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  it "should allow user to post a song" do
    wait_for_ajax
    page.type 'song_search_box', 'Friday'
    page.click 'song_search_button'
    wait_for_ajax
    page.click 'css=button.add_button'
    wait_for_ajax
    page.text?('Song was added!').should be_true
  end
end
