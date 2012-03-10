require 'spec_helper'

# Tests the Like model. White-box test.
# Author:: Melissa Winstanley
describe Like do

  # Set up variables used for liking.
  before(:each) do
    @user = FactoryGirl.create(:user)
    @song = FactoryGirl.create(:song)
    @post = Post.create_from_song(@song, @user)
    @attr = { :user_id => @user.id, :post_id => @post.id }
  end

  # Check that a particular ID field is validated
  # correctly.
  shared_examples "validation of IDs" do

    # Check that ID cannot be negative.
    it "should not allow negative IDs" do
      like = Like.new(@attr.merge(field => -1))
      like.should_not be_valid
    end

    # Check that ID must be an integer.
    it "should not allow non-integer IDs" do
      like = Like.new(@attr.merge(field => "hello"))
      like.should_not be_valid
    end
  end

  # Check that the user ID field is validated
  # correctly.
  describe "user ID validations" do
    it_behaves_like "validation of IDs" do
      let(:field) { :user_id }
    end
  end

  # Check that the post ID field is validated
  # correctly.
  describe "post ID validations" do
    it_behaves_like "validation of IDs" do
      let(:field) { :post_id }
    end
  end

  # Check that the create_new method.
  describe "create new method" do

    # Set up the original like.
    before(:each) do
      @like = Like.create_new(@user.id, @post.id)
    end

    # The first like with a particular user and post should be valid.
    it "should return a new like associated with the given user" do
      @like.should be_valid
    end

    # The second like with a particular user and post should not
    # be valid.
    it "should not allow likes with the same post and user" do
      @like.save
      like = Like.create_new(@user.id, @post.id)
      like.should_not be_valid
    end
  end
end
