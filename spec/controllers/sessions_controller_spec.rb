require 'spec_helper'

# Test the SessionsController. White-box test.
# Author:: Melissa Winstanley
describe SessionsController do
  render_views

  describe "before anything" do
    it "should not be signed in" do
      controller.should_not be_signed_in
    end
  end

  # Login / signup
  describe "POST 'create'" do
    # Set up a default valid user in the global request.env variable
    before(:each) do
      request.env["omniauth.auth"] = { "uid" => 619716339,
                                       "info" => { "first_name" => "Melissa",
                                                   "last_name" => "Winstanley",
                                                   "nickname" => "mwinst" } }
      post :create
      @user = User.find_by_facebook_id(619716339)
    end

    # perform illegal login
    describe "failure" do
      before(:each) do
        post :create
      end

      it "should have an error message when already logged in" do
        flash.now[:error].should =~ /signed in/i
      end

      it "should still be signed in" do
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        response.should redirect_to(users_url)
      end

    end

    # perform a legal login
    describe "success" do
      it "should sign the user in" do
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        response.should redirect_to(users_url)
      end

      it "should sign in the correct user" do
        controller.should be_current_user(@user)
      end
    end
  end

  # Logout
  describe "DELETE 'destroy'" do
    before(:each) do
      test_sign_in(FactoryGirl.build(:user))
      delete :destroy
    end

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

      it "should redirect to the user page" do
        response.should redirect_to(users_url)
      end
    end

    describe "success" do
      it "should sign a user out" do
        controller.should_not be_signed_in
      end

      it "should redirect to the user page" do
        response.should redirect_to(users_url)
      end
    end
  end
end