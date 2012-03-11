require 'spec_helper'
require 'likes_helper'

# Test the User model. White-box test.
# Author:: Brett Webber, Melissa Winstanley
describe User do

  # Creates a new user based on the given parameters.
  def new_user(params)
    user = User.new
    if !params.nil?
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.facebook_id = params[:facebook_id]
      user.username = params[:username]
    end
    user
  end

  # Creates a new user based on the given parameters.
  def create_user(params)
    user = new_user(params)
    user.save
    user
  end

  # Sets the attributes for an example user.
  before(:each) do
    @attr = {:first_name => "Example First Name",
             :last_name => "Example Last Name",
             :username => "Example Username", :facebook_id => 123}
    @secondary_attr = {:first_name => "Secondary Example First Name",
                       :last_name => "Secondary Example Last Name",
                       :username => "Username2", :facebook_id => 12345}
  end

  # Simple user creation with valid input.
  it "should succesfully create the user" do
    user = create_user(@attr)
    user.should_not eq(nil)
  end

  # Checks validation of a name.
  shared_examples "name validation" do

    # Tries to create a user with the name as an empty string.
    it "should be invalid if user has empty string as name" do
      user = new_user(@attr.merge(field => ""))
      user.should_not be_valid
    end

    # Tries to create a user with the name as nil.
    it "should be invalid if user has nil as name" do
      user = new_user(@attr.merge(field => nil))
      user.should_not be_valid
    end

    # Tries to create a user with the name as all whitespace.
    it "should be invalid if user has whitespace as name" do
      user = new_user(@attr.merge(field => "       "))
      user.should_not be_valid
    end

    # Tries to create two users with the same name.
    it "should allow two users to have the same name" do
      user = create_user(@attr)
      secondary_user = new_user(@secondary_attr.merge(
                                field => @secondary_attr[field]))
      secondary_user.should be_valid
    end

    # Tries to create a name that is too long
    it "should be invalid beyond its required length" do
      user = new_user(@attr.merge(field => "k" * (max_length + 1)))
      user.should_not be_valid
    end

    # Tries to create a name that is too long
    it "should be invalid below its required length" do
      user = new_user(@attr.merge(field => "k" * (min_length - 1)))
      user.should_not be_valid
    end
  end

  # Checks invalid and valid cases of the first name of the user.
  describe "first name validation" do
    it_should_behave_like "name validation" do
      let(:field) { :first_name }
      let(:max_length) { 30 }
      let(:min_length) { 1 }
    end
  end

  # Checks invalid and valid cases of the last name of the user.
  describe "last name validation" do
    it_should_behave_like "name validation" do
      let(:field) { :last_name }
      let(:max_length) { 30 }
      let(:min_length) { 1 }
    end
  end

  # Tries to create two users with the same first and last name.
  it "should allow two users to have the same first and last name" do
    user = create_user(@attr)
    secondary_user = new_user(@secondary_attr.merge(
                              :first_name => @attr[:first_name],
                              :last_name => @attr[:last_name]))
    secondary_user.should be_valid
  end

  # Checks invalid and valid cases of the username.
  describe "username validation" do
    it_should_behave_like "name validation" do
      let(:field) { :username }
      let(:max_length) { 25 }
      let(:min_length) { 3 }
    end
  end

  # Checks invalid and valid cases of the facebook_id
  describe "facebook_id validation" do

    # Tries to create a user with the facebook_id as nil
    it "should fail if user has nil as facebook_id" do
      user = new_user(@attr.merge(:facebook_id => nil))
      user.should_not be_valid
    end

    # Attempts to create two users with the same facebook_id
    it "should fail if two users have the same facebook_id" do
      user = create_user(@attr)
      secondary_user = new_user(@secondary_attr.merge(
                                :facebook_id => @attr[:facebook_id]))
      secondary_user.should_not be_valid
    end

    #Attempts to create a user with a negative facebook_id
    it "should fail if the facebook_id is negative" do
      user = new_user(@attr.merge(:facebook_id => -10))
      user.should_not be_valid
    end
  end

  # Test methods to subscribe and unsubscribe a user
  describe "subscribing" do

    # Set up the two users.
    before(:each) do
      @user = create_user(@attr)
      @other = FactoryGirl.create(:user)
    end

    # Start off not subscribing.
    it "shouldn't start off subscribed to another user" do
      @user.should_not be_subscribing(@other)
    end

    # Subscribe should allow you to subscribe to another user.
    it "should subscribe another user" do
      @user.subscribe!(@other)
      @user.should be_subscribing(@other)
    end

    # You can't subscribe to yourself.
    it "should not subscribe itself" do
      @user.subscribe!(@user)
      @user.should_not be_subscribing(@user)
    end

    # You should be able to unsubscribe.
    it "unsubscribe should unsubscribe a user" do
      @user.subscribe!(@other)
      @user.unsubscribe!(@other)
      @user.should_not be_subscribing(@user)
    end
  end

  # Test the method to return the user's subscriptions feed
  describe "feed" do

    # Set up posts for feed testing.
    before(:each) do
      @user = create_user(@attr)
      @other = FactoryGirl.create(:user)
      @song = FactoryGirl.create(:song)
      @user.subscribe!(@other)
      @post = Post.create_from_song(@song, @other)
    end

    # There should be a feed method.
    it "should have a means to access the feed" do
      @user.should respond_to(:feed)
    end

    # The feed should include posts from users that
    # the user is subscribed to.
    it "should include subscribed user's posts" do
      @user.feed.should include(@post)
    end
  end

  # Make sure that a user can be created with omniauth
  describe "omniauth user creation" do

    # Set up omniauth information.
    before(:each) do
      @auth = { "uid" => 619716339,
                "info" => { "first_name" => "Melissa",
                            "last_name" => "Winstanley",
                            "nickname" => "mwinst" } }
    end

    # There should be a method to create a user with omniauth.
    it "should allow creation with omniauth" do
      User.should respond_to(:create_with_omniauth)
    end

    # Test a successful omniauth user creation.
    describe "[success]" do
      it "should create a new user with valid info" do
        user = User.create_with_omniauth(@auth)
        user.should be_valid
      end
    end

    # Test faulty parameters to omniauth user creation
    describe "[failure]" do

      # Test that FB ID is required.
      it "should not work without a facebook ID" do
        @auth["uid"] = nil
        lambda { User.create_with_omniauth(@auth) }.should
                 raise_error(ActiveRecord::RecordInvalid)
      end

      # Test that first name is required.
      it "should not work without a first name" do
        @auth["info"]["first_name"] = nil
        lambda { User.create_with_omniauth(@auth) }.should
                 raise_error(ActiveRecord::RecordInvalid)
      end

      # Test that FB ID must be an integer.
      it "should not allow non-integer facebook IDs" do
        @auth["uid"] = "hello"
        lambda { User.create_with_omniauth(@auth) }.should
                 raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  # Check that liking and unliking behave correctly
  it_should_behave_like "likeable" do
    let(:likeable) { FactoryGirl.create(:user) }
  end
end
