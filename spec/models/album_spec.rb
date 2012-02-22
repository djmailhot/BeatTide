require 'spec_helper'

# Test the Album model. White-box test.
# Author:: Brett Webber
describe Album do

  # Should not allow an album to be created with an empty name
  it "should not allow empty name" do
    album_no_name = Album.new(:name => "")
    album_no_name.should_not be_valid
  end
  
  # Tries to make an album with a name of more than 200 characters
  it "should not allow names of greater than 200 characters" do
    album = Album.new(:name => "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
    album.should_not be_valid
  end

  # Tries to create two albums with the same name
  it "should not allow duplicate album names" do
    album = Album.create(:name => "Example Album Name")    
    secondary_album = Album.new(:name => "Example Album Name")    
    album.should_not be_valid
  end

  # Should not allow an album to be created with a nil name
  it "should not allow nil name" do
    album_nil_name = Album.new(:name => nil)
    album_nil_name.should_not be_valid
  end
end
