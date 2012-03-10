require 'spec_helper'

# White box unit test of Subscriptions Model
# Author:: Tyler Rigsby
describe Subscription do

  # Test subscription creation.
  describe "creating a subscription:" do

    # Set up users to use for subscriptions.
    before (:each) do
      @subscriber = Factory.create(:user)
      @subscribed = Factory.create(:user)
    end

    # Check that subscribing does the correct thing.
    describe "subscribing" do

      # Set up original subscription.
      before (:each) do
        @subscription = @subscriber.subscriptions.create!(
                        { :subscribed_id => @subscribed.id })
      end

      # User's subscriptions should be updated.
      it "should add a subscription to user's subscriptions" do
        @subscriber.subscriptions.should include @subscription
      end

      # User's reverse subscriptions should be updated.
      it "should add a subscription to subscribed's reverse_subscriptions" do
        @subscribed.reverse_subscriptions.should include @subscription
      end

      # Subscribed's list of subscribers should be updated.
      it "should add a subscriber to the subscribed's subscribers" do
        @subscribed.subscribers.should include @subscriber
      end

      # Subscriber should be subscribing to the right user.
      it "should add a subscribing to the subscriber's subscribings" do
        @subscriber.subscribing.should include @subscribed
      end

      # Subscription should have subscribed ID attribute.
      it "should respond to subscribed_id attribute" do
        @subscription.should respond_to(:subscribed_id)
      end

    end

    # Check subscription validations.
    describe "validations" do

      # Check that subscriber is required.
      it "should not allow a subscription without a subscriber" do
        Subscription.new({ :subscribed_id => @subscribed.id }).should_not be_valid
      end

      # Check that subscribed is required.
      it "should not allow a subscription without a subscribed" do
        @subscriber.subscriptions.build.should_not be_valid
      end
    end
  end
end
