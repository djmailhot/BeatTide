require 'spec_helper'

# Test the Song model. White-box test.
# Author:: Brett Webber
describe Song do
  
  before(:each) do
    @attr = { 
      :title => "Example Title",
      :api_id => "123"
    }
  end
  
  it "should create songs with likes set to 0" do
    song = Song.create(@attr)
    song.likes.should eq(0)
  end

  it "should not allow duplicate api_ids" do
    song_original = Song.create(@attr)
    song_duplicate_api_id = Song.new(@attr.merge(:title => "Hello"))
    song_duplicate_api_id.should_not be_valid
  end

  it "should not allow empty title" do
    song_no_title = Song.new(@attr.merge(:title => ""))
    song_no_title.should_not be_valid
  end

  it "should not allow nil title" do
    song_nil_title = Song.new(@attr.merge(:title => nil))
    song_nil_title.should_not be_valid
  end

  it "should not allow empty api_id" do
    song_no_api_id = Song.new(@attr.merge(:api_id => nil))
    song_no_api_id.should_not be_valid
  end

  it "should allow duplicate titles" do
    song_original = Song.create(@attr)
    song_duplicate_title = Song.new(@attr.merge(:api_id => 1234))
    song_duplicate_title.should be_valid
  end

  it "should increase likes by one when liked" do
    song = Song.create(@attr)
    song.like
    song.likes.should eq(1)
  end

  it "should increase likes when liked multiple times" do
    song = Song.create(@attr)
    song.like
    song.like
    song.like
    song.like
    song.likes.should eq(4)
  end
end
