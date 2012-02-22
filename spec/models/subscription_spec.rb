require 'spec_helper'

# White box unit test of Subscriptions Model
# Author:: Tyler Rigsby
describe Subscription do
  
  describe "creating a subscription:" do

    before (:each) do
      @subscriber = Factory.create(:user)
      @subscribed = Factory.create(:user)
    end

    describe "subscribing" do
      before (:each) do
        @subscription = @subscriber.subscriptions.create!({ :subscribed_id => @subscribed.id })
      end

      it "should add a subscription to user's subscriptions" do
        @subscriber.subscriptions.should include @subscription
      end

      it "should add a subscription to subscribed's reverse_subscriptions" do
        @subscribed.reverse_subscriptions.should include @subscription
      end
      
      it "should add a subscriber to the subscribed's subscribers" do
        @subscribed.subscribers.should include @subscriber
      end

      it "should add a subscring to the subscriber's subscribings" do
        @subscriber.subscribing.should include @subscribed
      end
      
      it "should respond to subscribed_id attribute" do
        @subscription.should respond_to(:subscribed_id)
      end

    end
    
    describe "validations" do
      it "should not allow a subscription without a subscriber" do
        Subscription.new({ :subscribed_id => @subscribed.id }).should_not be_valid
      end
      
      it "should not allow a subscription without a subscribed" do
        @subscriber.subscriptions.build.should_not be_valid
      end
    end
  end
end
