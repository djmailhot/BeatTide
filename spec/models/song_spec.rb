require 'spec_helper'
require 'song_metadata_helper'
require 'likes_helper'

# Test the Song model. Black-box test.
# Author:: Brett Webber, Melissa Winstanley
describe Song do

  # Sets up the creation parameters for a Song
  before(:each) do
    @params = {
      :class => Song,
      :title => "Example Title",
      :api_id => "123"
    }
  end

  # Check title and API ID validations.
  it_behaves_like "validating metadata"

  # Check liking behavior
  it_should_behave_like "likeable" do
    let(:likeable) { FactoryGirl.create(:song) }
  end
end
