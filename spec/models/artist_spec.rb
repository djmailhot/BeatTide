require 'spec_helper'

# Test the Artist model. White-box test.
# Author:: Brett Webber
describe Artist do

  # Should not allow an artist to be created with an empty name
  it "should not allow empty name" do
    artist_no_name = Artist.new(:title => "")
    artist_no_name.should_not be_valid
  end

  # Tries to make an artist with a name of more than 200 characters
  it "should not allow names of greater than 200 characters" do
    artist = Artist.new(:title => "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
    artist.should_not be_valid
  end

  # Tries to create two artists with the same name
  it "should not allow duplicate artist names" do
    artist = Artist.create(:title => "Example Artist Name")
    secondary_artist = Artist.new(:title => "Example Artist Name")
    artist.should_not be_valid
  end

  # Should not allow an artist to be created with a nil name
  it "should not allow nil name" do
    artist_nil_name = Artist.new(:title => nil)
    artist_nil_name.should_not be_valid
  end
end
