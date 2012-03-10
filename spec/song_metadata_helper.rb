# Common tests for validating, accessing, and creating song metadata.
# These can be reused to check that the names and API IDs of a model
# representing song metadata are valid, and that the find_or_create
# method works properly.
#
# Author:: Melissa Winstanley

require 'spec_helper'

# Returns a new object (not saved) with the given title and API ID.
# *params[:class]  the class of object to generate
# *params[:title]  the title of the object
# *params[:api_id] the API ID of the object
def new_metadata(params)
  metadata = params[:class].new
  metadata.title = params[:title]
  metadata.api_id = params[:api_id]
  metadata
end

# Checks that the "find_or_create" method works properly.
shared_examples_for "metadata with finding" do

  # Set up default attributes.
  before(:each) do
    @attr = { :class => described_class, :title => "Sunshine",
              :api_id => 10 }
  end

  # Method should create metadata if it doesn't exist yet.
  it "should return the right metadata if doesn't exist yet" do
    metadata = described_class.find_or_create(@attr[:api_id],
                                              @attr[:title])
    metadata.api_id.should eq(@attr[:api_id])
  end

  # Method should return metadata if it already exists.
  it "should return the right metadata if it already exists" do
    described_class.find_or_create(@attr[:api_id], @attr[:title])
    metadata = described_class.find_or_create(@attr[:api_id],
                                              @attr[:title])
    metadata.api_id.should eq(@attr[:api_id])
  end

  # Method should return nil if given API ID is not an integer.
  it "should return nil if the api_id is not an integer" do
    metadata = described_class.find_or_create("hello", @attr[:title])
    metadata.should be_nil
  end

  # Method should return nil if given API ID is nil.
  it "should return nil if the api_id is nil" do
    metadata = described_class.find_or_create(nil, @attr[:title])
    metadata.should be_nil
  end

  # Method should return nil if API ID is negative.
  it "should return nil if the api_id is negative" do
    metadata = described_class.find_or_create(-10, @attr[:title])
    metadata.should be_nil
  end

  # Method should return nil if title is nil.
  it "should return nil if the title is nil" do
    metadata = described_class.find_or_create(@attr[:api_id], nil)
    metadata.should be_nil
  end

  # Method should return nil if title is empty.
  it "should return nil if the title is blank" do
    metadata = described_class.find_or_create(@attr[:api_id], "")
    metadata.should be_nil
  end

  # Method should truncate titles over 200 characters.
  it "should truncate titles of over 200 characters" do
    metadata = described_class.find_or_create(@attr[:api_id],
                                              "k" * 201)
    metadata.title.should have(200).characters
  end
end

# The test cases that apply to all song metadata models, for
# validations.
shared_examples_for "validating metadata" do

  # Sets up attributes used by all of the tests
  before(:each) do
    @attr = { :class => described_class, :title => "Sunshine",
              :api_id => 10 }
  end

  # Metadata should be valid if passed valid parameters
  it "should validate correct paramaters" do
    metadata_valid = new_metadata(@attr)
    metadata_valid.should be_valid
  end

  # Check validations of title for metadata
  describe "title validation" do

    # Metadata should not be able to be created with a title that is nil
    it "should not allow nil title" do
      nil_title = new_metadata(@attr.merge(:title => nil))
      nil_title.should_not be_valid
    end

    # Should not allow metadata to be created with an empty title
    it "should not allow empty title" do
      metadata_no_name = new_metadata(@attr.merge(:title => "" ))
      metadata_no_name.should_not be_valid
    end

    # Should not allow metadata to be created with title over 200 chars
    it "should not allow names of greater than 200 characters" do
      metadata = new_metadata(@attr.merge(:title => "k" * 201))
      metadata.should_not be_valid
    end

    # Should allow metadata to repeat titles
    it "should allow duplicate titles" do
      metadata = new_metadata(@attr)
      metadata.save
      secondary_metadata = new_metadata(@attr.merge(
                                        :api_id => @attr[:api_id] + 1))
      secondary_metadata.should be_valid
    end
  end

  # Check validations of API ID for metadata
  describe "API ID validation" do

    # Should not allow metadata to be created with a nil API ID
    it "should not allow nil API IDs" do
      metadata = new_metadata(@attr.merge(:api_id => nil))
      metadata.should_not be_valid
    end

    # Should now allow metadata to be created with a negative API ID
    it "should not allow negative API IDs" do
      metadata = new_metadata(@attr.merge(:api_id => -10))
      metadata.should_not be_valid
    end

    # Should not allow metadata to be created with a non-integer API ID
    it "should not allow non-integer API IDs" do
      metadata = new_metadata(@attr.merge(:api_id => "hello"))
      metadata.should_not be_valid
    end

    # Should not allow metadata to repeat an API ID
    it "should not allow duplicate API IDs" do
      metadata = new_metadata(@attr)
      metadata.save
      secondary_metadata = new_metadata(@attr)
      secondary_metadata.should_not be_valid
    end
  end
end
