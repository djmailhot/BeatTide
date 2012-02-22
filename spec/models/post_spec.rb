require 'spec_helper'

# Tests the Post model. Test-driven-development, black-box test.
# Written before the Post model is implemented
# Author:: Melissa Winstanley
describe Post do

  # Set up basic user, song, and song parameters
  before(:each) do
    @user = FactoryGirl.create(:user)
    @song = FactoryGirl.create(:song)
    @params = { :song_id => @song.id }
  end

  # Test that parameters to creation of a post are validated
  describe "validation of post" do

    # Test that invalid parameters result in invalid posts
    describe "[failure]" do
      it "should fail without user" do
        Post.new(@params).should_not be_valid
      end

      it "should fail without song ID" do
        @params[:song_id] = nil
        @user.posts.build(@params).should_not be_valid
      end

      it "should fail with non-zero likes" do
        @params[:likes] = 8
        @user.posts.build(@params).should_not be_valid
      end

      it "should fail with non-integer song ID" do
        @params[:song_id] = "hello"
        @user.posts.build(@params).should_not be_valid
      end

      it "should fail with a negative song ID" do
        @params[:song_id] = -1
        @user.posts.build(@params).should_not be_valid
      end

      it "should fail with nonexistant song" do
        @params[:song_id] = Song.last.id + 1
        @user.posts.build(@params).should_not be_valid
      end
    end

    # Test a post that should validate successfully
    describe "[success]" do

      it "should create a post with valid data" do
        @user.posts.build(@params).should be_valid
      end

      it "should create a post with extra 0 likes param" do
        @params[:likes] = 0
        @user.posts.build(@params).should be_valid
      end
    end
  end

  # Test that posts are created correctly
  describe "initial creation" do
    before(:each) do
      @post = @user.posts.create(@params)
    end

    it "should create a valid post" do
      @post.should be_valid
    end

    it "should belong to the right user" do
      @post.user == @user
    end

    it "should have the right user ID" do
      @post.user_id == @user
    end

    it "should have the right song ID" do
      @post.song_id == @song.id
    end

    it "should start with 0 likes" do
      @post.likes == 0
    end
  end

  # Test finding all posts for subscribed users
  describe "getting all subscribed posts" do

    # Set up posts for each of 3 users
    before(:each) do
      @subscribed = FactoryGirl.create(:user)
      @uninvolved = FactoryGirl.create(:user)
      @user.subscribe!(@subscribed)
      @post_subsc = @subscribed.posts.create(@params)
      @post_subsc2 = @subscribed.posts.create(@params)
      @post_uninv = @uninvolved.posts.create(@params)
      @post_user = @user.posts.build(@params)
    end

    it "should allow users to get_subscribed_posts" do
      Post.should respond_to(:get_subscribed_posts)
    end

    it "should return a subscribed post if exists" do
      Post.get_subscribed_posts(@user).should include(@post_subsc)
    end

    it "should not include your own posts" do
      Post.get_subscribed_posts(@user).should_not include(@post_user)
    end

    it "should include multiple of subscribed's posts" do
      Post.get_subscribed_posts(@user).should include(@post_subsc2)
    end

    it "should not include uninvolved posts" do
      Post.get_subscribed_posts(@user).should_not include(@post_uninv)
    end

    it "should be empty for lonely users" do
      Post.get_subscribed_posts(@uninv).should be_empty
    end
  end

  # Test liking a post
  describe "counting likes" do

    before(:each) do
      @post = @user.posts.create(@params)
    end

    it "should allow users to like a post using like method" do
      Post.should respond_to(:like)
    end

    it "should increment likes by 1 with one like" do
      @post.like
      @post.likes.should eq(1)
    end

    it "should allow multiple likes" do
      @post.like
      @post.like
      @post.like
      @post.likes.should eq(3)
    end
  end
end