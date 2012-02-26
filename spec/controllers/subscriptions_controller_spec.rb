require 'spec_helper'

# White box test of Subscriptions Controller
# Author:: Tyler Rigsby
describe SubscriptionsController do
  describe "authorization" do
    it "shouldn't create subscription if not signed in" do
      post :create
      response.should redirect_to('/')

    end
    
    it "shouldn't delete if not signed in" do
      delete :destroy, :id => 1
      response.should redirect_to('/')
    end
  end

  # Add subscription
  describe "POST 'create'" do
    before(:each) do
      @subscriber = FactoryGirl.create(:user)
      @subscribed = FactoryGirl.create(:user)
      test_sign_in(@subscriber)
    end

    describe "success" do
      before(:each) do
        post :create, :id => @subscribed.id
      end

      it "should add a subscription to subscriber" do
        @subscriber.subscriptions.length.should eq(1)
      end
      
      it "should add a subscriber to subscribed" do
        @subscribed.subscribers.should include @subscriber
      end
      
      it "should redirect to the subscribed's page" do
        response.should redirect_to(@subscribed)
      end
    end

    describe "failure" do
      it "subscriber shouldn't get subscription on self-subscribe" do
        post :create, :id => @subscriber.id
        
        @subscriber.subscriptions.length.should eq(0)
      end

      it "subscriber shouldn't get subscribed on self-subscribe" do
        post :create, :id => @subscriber.id
        
        @subscriber.subscribers.should_not include @subscriber
      end

      it "should error on subscribe to non-existent user" do
        lambda {post :create, :id => 50}.should raise_error        
        flash.now[:error] = "The specified user doesn't exist";
      end

      

      it "should error on self-subscribe" do
        post :create, :id => @subscriber.id
        
        flash.now[:error].should =~ /subscribe to yourself/i
      end
      
      it "subscriber shouldn't get two subscriptions to same subscribed" do
        post :create, :id => @subscribed.id
        post :create, :id => @subscribed.id
        
        @subscriber.subscriptions.length.should eq(1)
      end

      it "subscribed shouldn't get two subscibers from same subscription" do
        post :create, :id => @subscribed.id
        post :create, :id => @subscribed.id
        
        @subscribed.subscribers.length.should eq(1)
      end

      it "should error on multi-subscribe" do
        post :create, :id => @subscribed.id 
        post :create, :id => @subscribed.id
        
        flash.now[:error].should =~ /already subscribed/i
      end
    end
  end

  # delete subscription
  describe "DELETE 'destroy'" do
    before (:each) do
      @subscriber = FactoryGirl.create(:user)
      test_sign_in(@subscriber)
      @subscribed = FactoryGirl.create(:user)

      post :create, :id => @subscribed.id
      @subscription = @subscriber.subscriptions[0]
    end
  
    describe "success" do
      it "should remove the subscription" do
        delete :destroy, :id => @subscribed.id
        
        Subscription.all.length.should eq(0)
      end
    end

    describe "failure" do
        it "should error on attempting to delete nonexistent subscription" do
          delete :destroy, :id => 50
          flash.now[:error].should =~ /doesn't exist/i
      end
    end
  end  
end
