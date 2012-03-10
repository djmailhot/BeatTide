require 'spec_helper'

# Test the SessionsController. White-box test.
# Author:: Melissa Winstanley
describe SessionsController do
  render_views

  # Test initial state of the application
  describe "before anything" do
    it "should not be signed in" do
      controller.should_not be_signed_in
    end

    it "should not have a user signed in" do
      controller.should_not be_current_user(FactoryGirl.build(:user))
    end
  end

  # Mistakes in login
  describe "faulty POST 'create'" do

    shared_examples "login_error" do
      it "should have an error message" do
        flash.now[:error].should =~ /improper/i
      end

      it "should not be signed in" do
        controller.should_not be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end
    end

    # Set up a default valid user in the global request.env variable
    before(:each) do
      request.env["omniauth.auth"] = { "uid" => 619716339,
                                       "info" => { "first_name" => "Melissa",
                                                   "last_name" => "Winstanley",
                                                   "nickname" => "mwinst" } }
    end

    describe "failure - no facebook ID" do
      before(:each) do
        request.env["omniauth.auth"]["uid"] = nil
        post :create
      end

      include_examples "login_error"
    end

    describe "failure - no name" do
      before(:each) do
        request.env["omniauth.auth"]["info"]["first_name"] = nil
	request.env["omniauth.auth"]["info"]["last_name"] = nil
        post :create
      end

      include_examples "login_error"
    end

    describe "failure - no authinfo" do
      before(:each) do
        request.env["omniauth.auth"] = nil
        post :create
      end

      include_examples "login_error"
    end
  end

  # Login / signup
  describe "POST 'create'" do
    before(:each) do
      request.env["omniauth.auth"] = { "uid" => 619716339,
                                       "info" => { "first_name" => "Melissa",
                                                   "last_name" => "Winstanley",
                                                   "nickname" => "mwinst" } }
      post :create
      @user = User.find_by_facebook_id(619716339)
    end

    # perform illegal double login
    describe "failure - double login" do
      before(:each) do
        post :create
      end

      it "should have an error message when already logged in" do
        flash.now[:error].should =~ /signed in/i
      end

      it "should still be signed in" do
        controller.should be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end
    end

    describe "failure - different duplicate login" do
      before(:each) do
        request.env["omniauth.auth"] = { "uid" => 619716338,
                                         "info" => { "first_name" => "Melissy",
                                                     "last_name" => "Winstanly",
                                                     "nickname" => "mwinst2" } }
        post :create
      end

      it "should have an error message when already logged in" do
        flash.now[:error].should =~ /signed in/i
      end

      it "should still be signed in" do
        controller.should be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end

      it "should still have initial user logged in" do
        controller.should be_current_user(@user)
      end

      it "should still find the other user" do
        user2 = User.find_by_facebook_id(619716338)
        user2.should_not eq(nil)
      end
    end

    # perform a legal login
    describe "success" do
      it "should sign the user in" do
        controller.should be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end

      it "should sign in the correct user" do
        controller.should be_current_user(@user)
      end
    end
  end

  # Logout
  describe "DELETE 'destroy'" do
    before(:each) do
      test_sign_in(FactoryGirl.create(:user))
      delete :destroy
    end

    # invalid signouts
    describe "failure" do
      before(:each) do
        test_sign_in(FactoryGirl.build(:user))
        delete :destroy
      end

      it "should have an error message if already logged in" do
        flash.now[:error].should =~ /signed out/i        
      end

      it "should still sign a user out" do
        controller.should_not be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end
    end

    # completed, correct signout
    describe "success" do
      it "should sign a user out" do
        controller.should_not be_signed_in
      end

      it "should redirect to the root page" do
        response.should redirect_to(root_url)
      end
      it "should not have an error" do
        flash.now[:error].should_not =~ /signed out/i        
      end
    end
  end
end
