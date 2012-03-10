require 'spec_helper'
require 'song_metadata_helper'

# Test the Artist model. Black-box test.
# Author:: Brett Webber, Melissa Winstanley
describe Artist do

  # Check title and API ID validations.
  it_behaves_like "metadata with finding"

  # Check finding and creating.
  it_behaves_like "validating metadata"
end
