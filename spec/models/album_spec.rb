require 'spec_helper'

# Test the Album model. White-box test.
# Author:: Brett Webber
describe Album do
  def new_album(params)
    album = Album.new
    album.title = params[:title]
    album.api_id = params[:api_id]
    album
  end

  before(:each) do
    @attr = { :title => "My album", :api_id => 10 }
  end

  describe "testing validations" do
    it "should validate correct paramaters" do
      album_valid = new_album(@attr)
      album_valid.should be_valid
    end

    # Should not allow an album to be created with an empty name
    it "should not allow empty name" do
      album_no_name = new_album(@attr.merge(:title => "" ))
      album_no_name.should_not be_valid
    end

    # Tries to make an album with a name of more than 200 characters
    it "should allow names of greater than 200 characters" do
      album = new_album(@attr.merge(:title => "k" * 201))
      album.should_not be_valid
    end

    # Tries to create two albums with the same name
    it "should not allow duplicate album API IDs" do
      album = FactoryGirl.create(:album)
      secondary_album = new_album(@attr.merge(:api_id => album.api_id))
      secondary_album.should_not be_valid
    end

    it "should not allow nil album API IDs" do
      album = new_album(@attr.merge(:api_id => nil))
      album.should_not be_valid
    end

    it "should not allow negative album API IDs" do
      album = new_album(@attr.merge(:api_id => -10))
      album.should_not be_valid
    end

    it "should not allow non-integer album API IDs" do
      album = new_album(@attr.merge(:api_id => "hello"))
      album.should_not be_valid
    end

    # Should not allow an album to be created with a nil name
    it "should not allow nil name" do
      album_nil_name = new_album(@attr.merge(:title => nil))
      album_nil_name.should_not be_valid
    end
  end
end
