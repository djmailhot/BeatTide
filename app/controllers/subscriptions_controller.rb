# Controller for creating/managing subscriptions. Contains
# functions for indexing as well as creating/destroying 
# subscriptions.
#
# Author:: Tyler Rigsby (mailto: rigsbyt@cs.uw.edu)
class SubscriptionsController < ApplicationController
  before_filter :authenticate

  # sets @subscriptions to the array of all subscriptions
  # and @title to "All subscriptions"
  def index
    @subscriptions = Subscription.all
    @title = "All subscriptions"
  end
  
  # creates a subscription from the current user to
  # params[:subscription][:subscribed_id]
  # redirects the user back to the page of the subscribed user
  def create
    @them = User.find(params[:id])
    if @them.nil?
      flash.now[:error] = "The specified user doesn't exist";
    elsif current_user == @them
      flash.now[:error] = "Cannot subscribe to yourself";
    elsif current_user.subscribing?(@them)
      flash.now[:error] = "You are already subscribed to this user";
    else
      current_user.subscribe!(@them)
      respond_to do |fmt|
        fmt.html {redirect_to @them}
        fmt.js
      end
    end
  end

  # destroys a subscription based on its subscription_id
  # redirects the user to the page of the user it was looking at
  def destroy
    subscription = current_user.subscriptions.find_by_subscribed_id(params[:id])
    if subscription.nil?
      flash.now[:error] = "Subscription doesn't exist";
    else
      subscription.destroy
    end
    respond_to do |fmt|
      fmt.js
    end
  end
end
