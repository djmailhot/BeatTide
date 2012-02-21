require 'spec_helper'

# White box test of Subscriptions Controller
# Author:: Tyler Rigsby
describe SubscriptionsController do
  
  describe "authorization" do
    it "shouldn't create subscription if not signed in" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "shouldn't delete if not signed in" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  # Add subscription
  describe "POST 'create'" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @subscribed = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "success" do
      it "should add a subscription to subscriber" do
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
        @user.subscriptions.length.should eq(1)
      end
      
      it "should add a subscriber to subscribed" do
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
        @user.subscribers.length.should eq(1)
      end
      
      it "should redirect to the subscribed's page" do
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
        response.should redirect_to(@subscribed)
      end
    end

    describe "failure" do
      it "subscriber shouldn't get subscription on self-subscribe" do
        post :create, :subscription => { :subscribed_id => @user.id }
        
        @user.subscriptions.length.should eq(0)
      end

      it "subscriber shouldn't get subscribed on self-subscribe" do
        post :create, :subscription => { :subscribed_id => @user.id }
        
        @user.subscribers.length.should eq(0)
      end

      it "should error on subscribe to non-existent user" do
        post :create, :subscription => { :subscribed_id => 50 }

        flash.now[:error].should =~ /user doesn't exist/i
      end

      it "should error on self-subscribe" do
        post :create, :subscription => { :subscribed_id => @user.id }
        
        flash.now[:error].should =~ /self subscribe/i
      end
      
      it "subscriber shouldn't get two subscriptions to same subscribed" do
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
        @user.subscriptions.length.should eq(1)
      end

      it "subscribed shouldn't get two subscibers from same subscription" do
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
        @user.subscribers.length.should eq(1)
      end

      it "should error on multi-subscribe" do
        post :create, :subscription => { :subscribed_id => @subscribed.id } 
        post :create, :subscription => { :subscribed_id => @subscribed.id }
        
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

      post :create, :subscription => { :subscribed_id => @subscribed.id }
      @subscription = @subscriber.subscriptions[0]
    end
  
    describe "success" do
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
    
    describe "failure" do
      it "should error on attempting to delete nonexistent subscription" do
        delete :destroy, :id => 50
        flash.now[:error].should =~ /not subscribed/i
      end
    end
  end  
end
