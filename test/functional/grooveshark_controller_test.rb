# Test class for the Grooveshark controller.
#
# Author:: Alex Miller, Harnoor Singh

require 'test_helper'

class GroovesharkControllerTest < ActionController::TestCase
  test "should get getInfo" do
    get :getInfo
    assert_response :success
  end

  test "should get findSong" do
    get :findSong
    assert_response :success
  end

  test "should get playSong" do
    get :playSong
    assert_response :success
  end

end
