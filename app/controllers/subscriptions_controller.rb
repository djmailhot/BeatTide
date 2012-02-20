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
  # params[:subscription][:subscribed_id]
  # redirects the user back to the page of the subscribed user
  def create
    @me = User.find(session[:user_id])
    @them = User.find(params[:subscription][:subscribed_id])
    if @me != @them
      @me.subscribe!(@them)
      redirect_to @them
    else
      # TODO: handle self-subscribe case
    end
  end


  # destroys a subscription based on its subscription_id
  # redirects the user to the page of the user it was looking at
  def destroy
    removed = Subscription.find(params[:id]).destroy
    redirect_to removed.subscribed
  end
end
