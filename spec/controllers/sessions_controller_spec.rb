require 'spec_helper'

# Test the SessionsController. White-box test.
# Author:: Melissa Winstanley
describe SessionsController do
  render_views

  # Login / signup
  describe "POST 'create'" do
    # Set up a default valid user in the global request.env variable
    before(:each) do
      request.env["omniauth.auth"] = { "uid" => 3,
                                       "info" => { "first_name" => "Melissa",
                                                   "last_name" => "Winstanley",
                                                   "nickname" => "mwinst" } }
    end

    # perform illegal login
    describe "failure" do
      it "should have an error message when already logged in" do
        post :create
        post :create
        flash.now[:error].should =~ /invalid/i
      end
    end

    # perform a legal login
    describe "success" do
      it "should sign the user in" do
        post :create
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        post :create
        response.should redirect_to(users_url)
      end
    end
  end

  # Logout
  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      test_sign_in(FactoryGirl.build(:user))
      delete :destroy
      controller.should_not be_signed_in
    end

    it "should redirect to the user page" do
      test_sign_in(FactoryGirl.build(:user))
      delete :destroy
      response.should redirect_to(users_url)
    end
  end
end