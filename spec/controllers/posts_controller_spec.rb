require 'spec_helper'

# Black-box tests for the PostsController (TDD-style)
# Tests the following methods of the public API:  create, destory, like
# Author:: David Mailhot
describe PostsController do
  render_views

  # Ensure only signed-in users can create and destroy
  describe "access control for non-signed-in user" do

    # Access - A non-auth'd user should not create
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(root_path)
    end

    # Access - A non-auth'd user should not destroy
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(root_path)
    end

    # Access - A non-auth'd user should not like
    it "should deny access to 'like'" do
      post :like, :id => 1
      response.should redirect_to(root_path)
    end
  end

  # Simulate creating a post
  describe "POST 'create'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    # Creation - Failure without a song attribute
    describe "[failure]" do
      # Shared test cases for creation failure, parameterized
      shared_examples "creation failure" do |params|
        it "should not create a post" do
          lambda do
            post :create, params
          end.should_not change(Post, :count)
        end

        it "should not create a post" do
          lambda do
            post :create, params
          end.should_not change(Post, :count)
        end

        it "should redirect to the user show page" do
          post :create, params
          response.should redirect_to("/error")
        end
      end

      describe "nil parameters" do
        before(:each) do
          @params = nil
        end

        it_behaves_like "creation failure", @params
      end

      describe "no song attribute" do
        before(:each) do
          @params = { :api_id => nil }
        end

        it_behaves_like "creation failure", @params
      end
    end

    # Creation - Success cases
    describe "[success]" do

      before(:each) do
        @new_song = FactoryGirl.create(:song)
        @params = { :api_id => @new_song.api_id }
      end

      it "should create a post" do
        lambda do
          post :create, @params
        end.should change(Post, :count).by(1)
      end

      # Creation - for multiple posts
      describe "creating multiple posts" do
        before(:each) do
          @next_params = { :api_id => FactoryGirl.create(:song).api_id }
        end

        it "should make multiple posts" do
          lambda do
            post :create, @params
            post :create, @next_params
          end.should change(Post, :count).by(2)
        end

        it "should allow posts of the same song" do
          lambda do
            post :create, @params
            post :create, @params
          end.should change(Post, :count).by(2)
        end
      end
    end

  end

  # Simulate deleting posts
  describe "DELETE 'destroy'" do

    # Delete - by a user who does not own the post in question
    describe "[failure] by non-owning user" do
      before(:each) do
        @owner = FactoryGirl.create(:user)
        @song = FactoryGirl.create(:song)
        @post = FactoryGirl.create(:post, :user => @owner, :song => @song)

        other_user = FactoryGirl.create(:user)
        test_sign_in(other_user)
      end

      it "should deny access" do
        lambda do
          delete :destroy, :id => @post
        end.should_not change(Post, :count)
      end
    end

    # Delete - success case
    describe "[success] by the owning user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
        @song = FactoryGirl.create(:song)
        @post = FactoryGirl.create(:post, :user => @user, :song => @song)
      end

      it "should destroy the post" do
        lambda do
          delete :destroy, :id => @post
        end.should change(Post, :count).by(-1)
      end
    end
  end

  # Incrementing the like count on a post
  describe "increment 'likes'" do
    before(:each) do
      @curr_user = FactoryGirl.create(:user)
      test_sign_in(@curr_user)

      @owner = FactoryGirl.create(:user)
      @song = FactoryGirl.create(:song)
      @post = FactoryGirl.create(:post, :user => @owner, :song => @song)
    end

    # Like - success case
    describe "[success]" do
      it "should increment the post likes by 1" do
        post :like, :id => @post.id
        Post.find(@post.id).like_count.should eq(1)
      end

      it "should increment the song likes by 1" do
        post :like, :id => @post.id
        Song.find(@song.id).like_count.should eq(1)
      end

      it "should increment the user likes by 1" do
        post :like, :id => @post.id
        User.find(@owner.id).like_count.should eq(1)
      end
    end

    # Like - liking your own posts
    describe "[success] liking one's own posts" do
      before(:each) do
        @own_post = FactoryGirl.create(:post, :user => @curr_user, :song => @song)
      end

      it "should increment the post likes by 1" do
        post :like, :id => @own_post.id
        Post.find(@own_post.id).like_count.should eq(1)
      end

      it "should increment the song likes by 1" do
        post :like, :id => @own_post.id
        Song.find(@song.id).like_count.should eq(1)
      end

      it "should not increment the user likes" do
        post :like, :id => @own_post.id
        User.find(@curr_user.id).like_count.should eq(0)
      end
    end

    # Like - can't like the same post more than once
    describe "liking the same post multiple times" do

      it "should not change total likes for the post" do
        post :like, :id => @post.id
        post :like, :id => @post.id
        Post.find(@post.id).like_count.should eq(0)
      end

      it "should not change total likes for the song" do
        post :like, :id => @post.id
        post :like, :id => @post.id
        Song.find(@song.id).like_count.should eq(0)
      end

      it "should not change total likes for the user" do
        post :like, :id => @post.id
        post :like, :id => @post.id
        User.find(@owner.id).like_count.should eq(0)
      end
    end
  end

end
