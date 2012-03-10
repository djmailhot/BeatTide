require 'spec_helper'
require 'song_metadata_helper'

# Test the Album model. Black-box test.
# Author:: Brett Webber, Melissa Winstanley
describe Album do

  # Check title and API ID validations.
  it_behaves_like "validating metadata"

  # Check finding and creating.
  it_behaves_like "metadata with finding"

end
