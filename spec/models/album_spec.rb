require 'spec_helper'

# Test the Album model. White-box test.
# Author:: Brett Webber
describe Album do

  # Should not allow an album to be created with an empty name
  it "should not allow empty name" do
    album_no_name = Album.new(:name => "")
    album_no_name.should_not be_valid
  end

  # Should not allow an album to be created with a nil name
  it "should not allow nil name" do
    album_nil_name = Album.new(:name => nil)
    album_nil_name.should_not be_valid
  end  
end
