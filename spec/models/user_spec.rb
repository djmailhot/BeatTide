require 'spec_helper'

# Test the User model. Black-box test.
# Author:: Brett Webber
describe User do
  
  # Sets the attributes for an example user
  before(:each) do
    @attr = {:first_name => "Example First Name", :last_name => "Example Last Name", :username => "Example Username", :facebook_id => 123}
    @secondary_attr = {:first_name => "Secondary Example First Name", :last_name => "Secondary Example Last Name", :username => "Secondary Example Username", :facebook_id => 12345}
  end

  # Simple user creation with valid input
  it "should succesfully create the user" do
    user = User.create(@attr)
    user.should_not eq(nil)
  end
 
  # Checks invalid and valid cases of the first name of the user
  describe "first name validation" do

    # Tries to create a user with the first name as an empty string
    it "should be invalid if user has empty string as first name" do
      user = User.new(@attr.merge(:first_name => ""))
      user.should_not be_valid    
    end

    # Tries to create a user with the first name as nil
    it "should be invalid if user has nil as first name" do
      user = User.new(@attr.merge(:first_name => nil))
      user.should_not be_valid    
    end

    # Tries to create a user with the first name as all whitespace
    it "should be invalid if user has whitespace as first name" do
      user = User.new(@attr.merge(:first_name => "       "))
      user.should_not be_valid    
    end

    # Tries to create two users with the same first name
    it "should allow two users to have the same first name" do
      user = User.create(@attr)
      secondary_user = User.new(@secondary_attr.merge(:first_name => @secondary_attr[:first_name]))
      secondary_user.should be_valid
    end
  end

  # Checks invalid and valid cases of the last name of the user
  describe "last name validation" do

    # Tries to create a user with the last name as an empty string
    it "should fail if user has empty string as last name" do
      user = User.new(@attr.merge(:last_name => ""))
      user.should_not be_valid    
    end

    # Tries to create a user with the last name as nil
    it "should fail if user has nil as last name" do
      user = User.new(@attr.merge(:last_name => nil))
      user.should_not be_valid    
    end

    # Tries to create a user with the last name as all whitespace
    it "should fail if user has whitespace as last name" do
      user = User.new(@attr.merge(:last_name => "       "))
      user.should_not be_valid    
    end

    # Tries to create two users with the same last name
    it "should allow two users to have the same last name" do
      user = User.create(@attr)
      secondary_user = User.new(@secondary_attr.merge(:last_name => @attr[:last_name]))
      secondary_user.should be_valid
    end
  end
  
  # Tries to create two users with the same first and last name
  it "should allow two users to have the same first and last name" do
    user = User.create(@attr)
    secondary_user = User.new(@secondary_attr.merge(:first_name => @attr[:first_name], :last_name => @attr[:last_name]))
    secondary_user.should be_valid
  end

  # Checks invalid and valid cases of the username
  describe "username validation" do

    # Tries to create a user with the username as an empty string
    it "should fail if user has empty string as username" do
      user = User.new(@attr.merge(:username => ""))
      user.should_not be_valid    
    end

    # Tries to create a user with the username as nil
    it "should fail if user has nil as username" do
      user = User.new(@attr.merge(:username => nil))
      user.should_not be_valid    
    end

    # Tries to create a user with the username as all whitespace
    it "should fail if user has whitespace as username" do
      user = User.new(@attr.merge(:username => "       "))
      user.should_not be_valid    
    end
    
    # Attempts to create two users with the same username 
    it "should fail if two users have the same username" do
      user = User.create(@attr)
      secondary_user = User.new(@secondary_attr.merge(:username => @attr[:username]))
      secondary_user.should_not be_valid    
    end

    # Attempts to create a user with a username shorter than 4 characters 
    it "should if a username is shorter than 4 characters" do
      user = User.new(@attr.merge(:username => "jkl"))
      user.should_not be_valid    
    end

    # Attempts to create a user with a username longer than 25 characters 
    it "should if a username is longer than 25 characters" do
      user = User.new(@attr.merge(:username => "jjjjjjjjjjjjjjjjjjjjjjjjjj"))
      user.should_not be_valid    
    end
  end

  # Checks invalid and valid cases of the facebook_id
  describe "facebook_id validation" do

    # Tries to create a user with the facebook_id as nil
    it "should fail if user has nil as facebook_id" do
      user = User.new(@attr.merge(:facebook_id => nil))
      user.should_not be_valid    
    end

    # Attempts to create two users with the same facebook_id 
    it "should fail if two users have the same facebook_id" do
      user = User.create(@attr)
      secondary_user = User.new(@secondary_attr.merge(:facebook_id => @attr[:facebook_id]))
      secondary_user.should_not be_valid    
    end

    #Attempts to create a user with a negative facebook_id
    it "should fail if the facebook_id is negative" do
      user = User.new(@attr.merge(:facebook_id => -10))
      user.should_not be_valid
    end
  end

  # Tests various parts of the liking functionality
  describe "likes validation" do
    
    # Creates a new User and checks if their likes are set to 0
    it "should create users with likes set to 0" do
      user = User.create(@attr)
      user.likes.should eq(0)
    end      

    # Tries to create user with something other than 0 likes
    it "should create users with likes set to 0" do
      user = User.create(@attr.merge(:likes => 123))
      user.likes.should eq(0)
    end
  end

  # Checks invalid and valid cases of the facebook_id
  describe "activation" do

    # Tries to create a user with the facebook_id as nil
    it "should fail if user has nil as facebook_id" do
      user = User.new(@attr.merge(:facebook_id => nil))
      user.should_not be_valid
    end

    # Attempts to create two users with the same facebook_id
    it "should fail if two users have the same facebook_id" do
      user = User.create(@attr)
      secondary_user = User.new(@secondary_attr.merge(:facebook_id => @attr[:facebook_id]))
      secondary_user.should_not be_valid
    end
  end

  # Test methods to subscribe and unsubscribe a user
  describe "subscribing" do
    before(:each) do
      @user = User.create(@attr)
      @other = FactoryGirl.create(:user)
    end

    it "should subscribe another user" do
      @user.subscribe!(@other)
      @user.should be_subscribing(@other)
    end

    it "should not subscribe itself" do
      @user.subscribe!(@user)
      @user.should_not be_subscribing(@user)
    end

    it "unsubscribe should unsubscribe a user" do
      @user.subscribe!(@other)
      @user.unsubscribe!(@other)
      @user.should_not be_subscribing(@user)
    end
  end

  # Test the method to return the user's subscriptions feed
  describe "feed" do
    before(:each) do
      @user = User.create(@attr)
      @other = FactoryGirl.create(:user)
      @user.subscribe!(@other)
      @post = @other.posts.create!( { :song_id => 3 } )
    end

    it "should have a means to access the feed" do
      @user.should respond_to(:feed)
    end

    it "should include subscribed user's posts" do
      @user.feed.should include(@post)
    end
  end

  # Make sure that a user can be created with omniauth
  describe "omniauth user creation" do
    before(:each) do
      @auth = { "uid" => 619716339,
                "info" => { "first_name" => "Melissa",
                            "last_name" => "Winstanley",
                            "nickname" => "mwinst" } }
    end

    it "should allow creation with omniauth" do
      User.should respond_to(:create_with_omniauth)
    end

    # Test a successful omniauth user creation
    describe "[success]" do
      it "should create a new user with valid info" do
        user = User.create_with_omniauth(@auth)
        user.should be_valid
      end
    end

    # Test faulty parameters to omniauth user creation
    describe "[failure]" do
      it "should not work without a facebook ID" do
        @auth["uid"] = nil
        user = User.create_with_omniauth(@auth)
        user.should_not be_valid
      end

      it "should not work without a first name" do
        @auth["first_name"] = nil
        user = User.create_with_omniauth(@auth)
        user.should_not be_valid
      end

      it "should not allow non-integer facebook IDs" do
        @auth["uid"] = "hello"
        user = User.create_with_omniauth(@auth)
        user.should_not be_valid
      end
    end

  end
end