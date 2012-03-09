require 'spec_helper'

# Test the Song model. White-box test.
# Author:: Brett Webber
describe Song do

  def new_song(params)
    song = Song.new
    song.title = params[:title]
    song.api_id = params[:api_id]
    song
  end

  # Sets up the creation parameters for a Song
  before(:each) do
    @attr = {
      :title => "Example Title",
      :api_id => "123"
    }
  end

  # Songs should be created with likes intialized to 0
  it "should create songs with likes set to 0" do
    song = FactoryGirl.create(:song)
    song.like_count.should eq(0)
  end

  # api_ids should be unique, so there should not be multiple songs with the same api_id
  it "should allow duplicate titles" do
    song_original = FactoryGirl.create(:song)
    song_duplicate_title = new_song(@attr.merge(:title => song_original.title))
    song_duplicate_title.should be_valid
  end

  # A Song should not be able to be created with a title that is the empty string
  it "should not allow empty title" do
    song_no_title = new_song(@attr.merge(:title => ""))
    song_no_title.should_not be_valid
  end

  # A Song should not be able to be created with a title that consists only of whitespace
  it "should not allow empty title" do
    song_no_title = new_song(@attr.merge(:title => "      "))
    song_no_title.should_not be_valid
  end

  # A Song should not be able to be created with a title that is nil
  it "should not allow nil title" do
    song_nil_title = new_song(@attr.merge(:title => nil))
    song_nil_title.should_not be_valid
  end

  # A Song should not be able to be created with a nil api_id
  it "should not allow empty api_id" do
    song_no_api_id = new_song(@attr.merge(:api_id => nil))
    song_no_api_id.should_not be_valid
  end

  # A Song should be allowed to be created with the same title as another Song
  it "should not allow duplicate API IDs" do
    song_original = FactoryGirl.create(:song)
    song_duplicate_id = new_song(@attr.merge(:api_id => song_original.api_id))
    song_duplicate_id.should_not be_valid
  end

  # Liking once should increase the likes attribute by one
  it "should increase likes by one when liked" do
    song = FactoryGirl.create(:song)
    song.like!
    song.like_count.should eq(1)
  end

  # Liking multiple times should increase the likes attribute by the amount of times that it was liked
  it "should increase likes when liked multiple times" do
    song = FactoryGirl.create(:song)
    song.like!
    song.like!
    song.like!
    song.like!
    song.like_count.should eq(4)
  end
end
