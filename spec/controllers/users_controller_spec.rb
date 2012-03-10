require 'spec_helper.rb'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

# Test the Users controller.  Black-box test.
#Author:: Harnoor Singh

# Signed in

describe UsersController do
  render_views

  # Ensure only signed in users can view user pages
  describe "GET 'show' for not signed in user" do

    # Show user given ID
    it "Should redirect to sign-in page" do
      @user = FactoryGirl.create(:user)
      get :show, :id => @user
      response.should redirect_to(root_url)
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    # Show user given ID
    it "Should show the correct user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    # Show called on invalid ID
    it "Should redirect to error page if invalid ID is passed" do
      get :show, :id => 538474848
      response.should redirect_to("/error")
    end
  end

  describe "GET 'edit' with signed in user" do

    # Sign in a user
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    # Edit user given ID
    it "Should set User to correct user" do
      get :edit, :id => @user
      assigns(:user).should == @user
    end

    # Edit should fail when editing some other users data
    it "Should redirect to current user edit even when editing another user" do
      @user2 = FactoryGirl.create(:user)
      get :edit, :id => @user2
      assigns(:user).should == @user
    end
  end

  describe "GET 'edit' with user not signed in" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    # Should not be able to edit if not signed in
    it "Should fail when attempting to edit while not signed in" do
      get :edit, :id => 0
      response.should redirect_to(root_path)
    end
  end


  describe "GET 'index' without signed in user" do

    # Shouldn't be able to view the user list if you're not logged in
    it "It should redirect the user to a login page" do
      get :index
      response.should redirect_to(root_path)
    end
  end

  after(:each) do
    DatabaseCleaner.clean
  end
end
