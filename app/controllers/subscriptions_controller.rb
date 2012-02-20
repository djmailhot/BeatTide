# Controller for creating/managing subscriptions. Contains
# functions for indexing as well as creating/destroying 
# subscriptions.
#
# Author:: Tyler Rigsby (mailto: rigsbyt@cs.uw.edu)
class SubscriptionsController < ApplicationController

  # sets @subscriptions to the array of all subscriptions
  # and @title to "All subscriptions"
  def index
    @subscriptions = Subscription.all
    @title = "All subscriptions"
  end

  # creates a subscription from the current user to
  # params[:user]
  def create
    @me = User.find(session[:user_id])
    @them = User.find(params[:subscription][:subscribed_id])
    if @me != @them
      @me.subscribe!(@them)
    else
      # TODO: handle self-subscribe case
    end
  end

  
  def update
    redirect_to User.find(Subscription.find(params[:id]).subscribed_id)
  end



  # destroys a subscription based on its subscription_id
  def destroy
    Subscription.find(params[:id]).destroy
  end
end
