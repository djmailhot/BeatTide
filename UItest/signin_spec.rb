require "selenium/client"
require 'spec_helper'

def wait_for_ajax(timeout=5000)
  js_condition = 'selenium.browserbot.getCurrentWindow().jQuery.active == 0'
  @selenium_driver.wait_for_condition(js_condition, timeout)
end

describe "Signin page" do
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
    page.text?('Hello, music lover!').should be_true
  end

  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  def wait_for_ajax(timeout=5000)
    js_condition = 'selenium.browserbot.getCurrentWindow().jQuery.active == 0'
    @selenium_driver.wait_for_condition(js_condition, timeout)
  end

  it "should accept valid login" do
    page.click 'fb_button', :wait_for => :page
    page.type 'email', 'beattide@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    page.text?('Signed in as').should be_true
  end

  # it "should not allow user to access user pages before signing in" do
  #   page.open "/#!/users"
  #   wait_for_ajax
  #   page.text?('Hello, music lover!').should be_true
  # end

  # it "should not allow user to access users before signing in" do
  #   page.open "/#!/users/1"
  #   wait_for_ajax
  #   page.text?('Hello, music lover!').should be_true
  # end

  # it "should not allow user to access user search before signing in" do
  #   page.open "/#!/users/search"
  #   wait_for_ajax
  #   page.text?('Hello, music lover!').should be_true
  # end

  it "should allow user to access FAQ before signing in by clicking the link" do
    page.click 'link=FAQ'
    wait_for_ajax
    page.text?('What is BeatTide?').should be_true
  end

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
