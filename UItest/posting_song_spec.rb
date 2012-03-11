require 'selenium/client'
require 'ui_spec_helper'

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
    page.type 'email', 'beatertider@gmail.com'
    page.type 'pass', 'honeybadger'
    page.click 'loginbutton', :wait_for => :page
    wait_for_ajax
    page.text?('Signed in as').should be_true    
  end

  after(:each) do
    @selenium_driver.close_current_browser_session
  end

  it "should allow user to post a song" do
    page.type 'song_search_box', 'Friday'
    page.click 'song_search_button'
    wait_for_ajax
    page.click 'css=button.add_button'
    wait_for_ajax
    page.text?('added to your posts').should be_true
  end

  it "should allow user to delete a song" do
    wait_for_ajax
    page.click 'css=span.delete_post a'
    wait_for_ajax
    page.text?('Deleted').should be_true
  end
end
