require 'spec_helper'

# Test the Artist model. White-box test.
# Author:: Brett Webber
describe Artist do

  # Should not allow an artist to be created with an empty name
  it "should not allow empty name" do
    artist_no_name = Artist.new(:name => "")
    artist_no_name.should_not be_valid
  end

  # Should not allow an artist to be created with a nil name
  it "should not allow nil name" do
    artist_nil_name = Artist.new(:name => nil)
    artist_nil_name.should_not be_valid
  end  
end
