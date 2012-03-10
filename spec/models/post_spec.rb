require 'spec_helper'

# Tests the Post model. Test-driven-development, black-box test.
# Written before the Post model is implemented.
# Author:: Melissa Winstanley
describe Post do

  # Set up basic user, song, and song parameters.
  before(:each) do
    @user = FactoryGirl.create(:user)
    @song = FactoryGirl.create(:song)
    @params = { :song_id => @song.id }
  end

  # Test that parameters to creation of a post are validated.
  describe "validation of post" do

    # Test that invalid parameters result in invalid posts.
    describe "[failure]" do

      # Not valid with a nil user.
      it "should fail without user" do
        lambda { Post.create_from_song(@song, nil) }.should
                   raise_error(ActiveRecord::RecordInvalid)
      end

      # Not valid with a nil song.
      it "should fail without song" do
        lambda { Post.create_from_song(nil, @user) }.should
                   raise_error(ActiveRecord::RecordInvalid)
      end

      # Not valid without either user or song.
      it "should not allow direct creation without params" do
        @user.posts.new.should_not be_valid
      end
    end

    # Test a post that should validate successfully.
    describe "[success]" do

      # Valid with a valid song and user.
      it "should create a post with valid data" do
        Post.create_from_song(@song, @user).should be_valid
      end
    end
  end

  # Test that posts are created correctly.
  describe "initial creation" do

    # Set up initial post.
    before(:each) do
      @post = Post.create_from_song(@song, @user)
    end

    # Created post should belong to the provided user.
    it "should belong to the right user" do
      @post.user == @user
    end

    # Created post should have the right user ID.
    it "should have the right user ID" do
      @post.user_id == @user
    end

    # Created post should have the right song ID.
    it "should have the right song ID" do
      @post.song_id == @song.id
    end

    # Created post should start with 0 likes.
    it "should start with 0 likes" do
      @post.like_count == 0
    end
  end

  # Test finding all posts for subscribed users.
  describe "getting all subscribed posts" do

    # Set up posts for each of 3 users.
    before(:each) do
      @subscribed = FactoryGirl.create(:user)
      @uninvolved = FactoryGirl.create(:user)
      @user.subscribe!(@subscribed)
      @post_subsc = Post.create_from_song(@song, @subscribed)
      @post_subsc2 = Post.create_from_song(@song, @subscribed)
      @post_uninv = Post.create_from_song(@song, @uninvolved)
      @post_user = Post.create_from_song(@song, @user)
    end

    # You should be able to access the method to get posts.
    it "should allow users to get_subscribed_posts" do
      Post.should respond_to(:get_subscribed_posts)
    end

    # Should include posts for users that given user is subscribed
    # to.
    it "should return a subscribed post if exists" do
      Post.get_subscribed_posts(@user).should include(@post_subsc)
    end

    # Shouldn't include the given user's posts.
    it "should not include your own posts" do
      Post.get_subscribed_posts(@user).should_not include(@post_user)
    end

    # Should include more than one post if applicable.
    it "should include multiple of subscribed's posts" do
      Post.get_subscribed_posts(@user).should include(@post_subsc2)
    end

    # Shoudn't include other not subscribed posts.
    it "should not include uninvolved posts" do
      Post.get_subscribed_posts(@user).should_not include(@post_uninv)
    end

    # If a user has no subscriptions, should be empty.
    it "should be empty for lonely users" do
      Post.get_subscribed_posts(@uninv).should be_empty
    end
  end

  # Test liking a post.
  describe "counting likes" do

    # Set up original post.
    before(:each) do
      @post = Post.create_from_song(@song, @user)
    end

    # Should increase likes on first like.
    it "should increment likes by 1 with one like" do
      @post.like!(@user)
      @post.like_count.should eq(1)
    end

    # Should do nothing on second like.
    it "should increment likes by 1 with one like" do
      @post.like!(@user)
      @post.like!(@user)
      @post.like_count.should eq(1)
    end

    # Should allow multiple users to like the post.
    it "should allow multiple likes" do
      @post.like!(@user)
      @post.like!(FactoryGirl.create(:user))
      @post.like!(FactoryGirl.create(:user))
      @post.like_count.should eq(3)
    end
  end
end
