require 'spec_helper.rb'

# Test the Users controller.  Black-box test.
#Author:: Harnoor Singh

# Signed in

describe UsersController do 
  render_views

  # Ensure only signed in users can view user pages
  describe "GET 'show' for not signed in user" do

    # Show user given ID
    it "Should show the correct user" do
      @user = FactoryGirl.create(:user)
      get :show, :id => @user
      response.should redirect_to('page#index')
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
    it "Should fail with flash.now if invalid ID is passed" do 
      get :show, :id => 538474848
      flash.now[:error].should =~ /invalid/i
    end
  end
  
  describe "POST 'create'" do

    # Set the attributes for creating a new user
    before(:each) do
      @attr = {:first_name => "Harnoor", :last_name => "Singh",
        :username => "hsingh", :facebook_id => 11925848}
    end

    # Create user with valid input
    it "Should create the user" do 
      post :create, :user => @attr
      response.should be_success
    end

    # Attempt to create user with no first name
    it "should fail if the user has no first name" do 
      @attr.merge(:first_name => "")
      post :create, :user => @attr
      flash.now[:error].should =~ /invalid/i
    end

    # Attempt to create user with no last name
    it "should fail if the user has no last name" do 
      @attr.merge(:last_name => "")
      post :create, :user => @attr
      flash.now[:error].should =~ /invalid/i
    end

    # Attempt to create user with no username
    it "should fail if the user has no username" do 
      @attr.merge(:username => "")
      post :create, :user => @attr
      flash.now[:error].should =~ /invalid/i
    end

    # Attempt to create user with no facebook ID
    it "should fail if the user has no facebook_id" do 
      @attr.merge(:facebook_id => nil)
      post :create, :user => @attr
      flash.now[:error].should =~ /invalid/i
    end
  end


  describe "GET 'edit' with signed in user" do

    # Sign in a user
    before(:each) do
      @user = FactoryGirl(:user)
      test_sign_in(@user)
    end

    # Edit user given ID
    it "Should set User to correct user" do
      get :edit, :id => @user
      assigns(:user).should == @user
    end

    # Edit should fail when editing some other users data
    it "Should fail with flash.now if editing another user" do
      @user2 = FactoryGirl(:user)
      get :edit, :id => @user2
      flash.now[:error].should =~ /invalid/i
    end

    # Edit called on invalid ID
    it "Should fail with flash.now if invalid ID is passed" do 
      get :edit, :id => 538474848
      flash.now[:error].should =~ /invalid/i
    end
  end

  describe "GET 'edit' with user not signed in" do
    
    before(:each) do
      @user = FactoryGirl(:user)
    end

    # Should not be able to edit if not signed in
    it "Should fail when attempting to edit while not signed in" do
      get :edit, :id => 0
      response.should redirect_to('page#index')
    end
  end


  describe "GET 'index' without signed in user" do

    # Shouldn't be able to view the user list if you're not logged in
    it "It should redirect the user to a login page" do
      get :index
      response.should redirect_to('page#index')
    end
  end
end
    

  
