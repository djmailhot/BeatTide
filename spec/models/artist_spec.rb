require 'spec_helper'

# Test the Artist model. White-box test.
# Author:: Brett Webber
describe Artist do
  def new_artist(params)
    artist = Artist.new
    artist.title = params[:title]
    artist.api_id = params[:api_id]
    artist
  end

  before(:each) do
    @attr = { :title => "Beats", :api_id => 10 }
  end

  describe "testing validations" do
    it "should validate correct paramaters" do
      artist_valid = new_artist(@attr)
      artist_valid.should be_valid
    end

    # Should not allow an artist to be created with an empty name
    it "should not allow empty name" do
      artist_no_name = new_artist(@attr.merge(:title => "" ))
      artist_no_name.should_not be_valid
    end

    # Tries to make an artist with a name of more than 200 characters
    it "should allow names of greater than 200 characters" do
      artist = new_artist(@attr.merge(:title => "k" * 201))
      artist.should_not be_valid
    end

    # Tries to create two artists with the same name
    it "should not allow duplicate artist API IDs" do
      artist = FactoryGirl.create(:artist)
      secondary_artist = new_artist(@attr.merge(:api_id => artist.api_id))
      secondary_artist.should_not be_valid
    end

    it "should not allow nil artist API IDs" do
      artist = new_artist(@attr.merge(:api_id => nil))
      artist.should_not be_valid
    end

    it "should not allow negative artist API IDs" do
      artist = new_artist(@attr.merge(:api_id => -10))
      artist.should_not be_valid
    end

    it "should not allow non-integer artist API IDs" do
      artist = new_artist(@attr.merge(:api_id => "hello"))
      artist.should_not be_valid
    end

    # Should not allow an artist to be created with a nil name
    it "should not allow nil name" do
      artist_nil_name = new_artist(@attr.merge(:title => nil))
      artist_nil_name.should_not be_valid
    end
  end
end
