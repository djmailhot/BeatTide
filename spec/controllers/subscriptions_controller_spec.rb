require 'spec_helper'

# White box test of Subscriptions Controller
# Author:: Tyler Rigsby
describe SubscriptionsController do
  render_views

  # Add subscription
  describe "POST 'create'" do
    before(:each) do
      @user = User.find(test_sign_in(FactoryGirl.create(:user, :facebook_id => Factory.next(:facebook_id))))
      @subscribed = FactoryGirl.create(:user, :id => 2, :facebook_id => Factory.next(:facebook_id))
      @subscribed.save
    end

    it "should add a subscription to subscriber" do
      post :create, :subscription => {:subscribed_id => @subscribed.id }

      @user.subscriptions.length.should eq(1)
    end

    it "should add a subscriber to subscribed" do
      post :create, :subscription => {:subscribed_id => @subscribed.id }
      
      @user.subscribers.length.should eq(1)
    end
    
    it "should redirect to the subscribed's page" do
      post :create, :subscription => {:subscribed_id => @subscribed.id }
      
      response.should redirect_to(@subscribed)
    end
    
    it "should fail for self-subscribes" do
      post :create, :subscription => {:subscribed_id => @user.id }
      
      @user.subscriptions.length.should eq(0)
      @user.subscribers.length.should eq(0)
    end
    
    it "shouldn't allow multi-subscribes" do
      post :create, :subscription => {:subscribed_id => @subscribed.id }
      post :create, :subscription => {:subscribed_id => @subscribed.id }
      
      @user.subscriptions.length.should eq(1)
      @user.subscribers.length.should eq(1)
    end
  end

  # delete subscription
  describe "DELETE 'destroy'" do
    before (:each) do
      @subscriber = User.find(test_sign_in(FactoryGirl.create(:user, :facebook_id => Factory.next(:facebook_id))))
      @subscribed = FactoryGirl.create(:user, :id => 2, :facebook_id => Factory.next(:facebook_id))
      post :create, :subscription => {:subscribed_id => @subscribed.id }
      @subscription = @subscriber.subscriptions[0]
    end
  
    it "should remove the subscription" do
      delete :destroy, :id => @subscription.id

      Subscription.all.length.should eq(0)
      @subscriber.subscriptions.length.should eq(0)
    end

    it "should redirect to the subscribed's page" do
      delete :destroy, :id => @subscription
      response.should redirect_to(@subscribed)
    end
  end  
end
  
