require 'spec_helper'

# Test the Song model. White-box test.
# Author:: Brett Webber
describe Song do

  # Sets up the creation parameters for a Song
  before(:each) do
    @attr = {
      :title => "Example Title",
      :api_id => "123"
    }
  end

  # Songs should be created with likes intialized to 0
  it "should create songs with likes set to 0" do
    song = Song.create(@attr)
    song.like_count.should eq(0)
  end

  # Tries to create song with something other than 0 likes
  it "should create songs with likes set to 0" do
    song = Song.create(@attr.merge(:like_count => 123))
    song.like_count.should eq(0)
  end

  # api_ids should be unique, so there should not be multiple songs with the same api_id
  it "should not allow duplicate api_ids" do
    song_original = Song.create(@attr)
    song_duplicate_api_id = Song.new(@attr.merge(:title => "Hello"))
    song_duplicate_api_id.should_not be_valid
  end

  # A Song should not be able to be created with a title that is the empty string
  it "should not allow empty title" do
    song_no_title = Song.new(@attr.merge(:title => ""))
    song_no_title.should_not be_valid
  end

  # A Song should not be able to be created with a title that consists only of whitespace
  it "should not allow empty title" do
    song_no_title = Song.new(@attr.merge(:title => "      "))
    song_no_title.should_not be_valid
  end

  # A Song should not be able to be created with a title that is nil
  it "should not allow nil title" do
    song_nil_title = Song.new(@attr.merge(:title => nil))
    song_nil_title.should_not be_valid
  end

  # A Song should not be able to be created with a nil api_id
  it "should not allow empty api_id" do
    song_no_api_id = Song.new(@attr.merge(:api_id => nil))
    song_no_api_id.should_not be_valid
  end

  # A Song should be allowed to be created with the same title as another Song
  it "should allow duplicate titles" do
    song_original = Song.create(@attr)
    song_duplicate_title = Song.new(@attr.merge(:api_id => 1234))
    song_duplicate_title.should be_valid
  end

  # Liking once should increase the likes attribute by one
  it "should increase likes by one when liked" do
    song = Song.create(@attr)
    song.like!
    song.like_count.should eq(1)
  end

  # Liking multiple times should increase the likes attribute by the amount of times that it was liked
  it "should increase likes when liked multiple times" do
    song = Song.create(@attr)
    song.like!
    song.like!
    song.like!
    song.like!
    song.like_count.should eq(4)
  end
end
