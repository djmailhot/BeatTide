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
    @them = User.find(params[:subscription][:subscribed_id])
    if current_user == @them
      # TODO: handle self-subscribe case
    elsif current_user.subscribing?(@them)
      #TODO: handle multi-subscribe case
    else
      current_user.subscribe!(@them)
      redirect_to @them
    end
  end


  # destroys a subscription based on its subscription_id
  # redirects the user to the page of the user it was looking at
  def destroy
    removed = Subscription.find(params[:id]).destroy
    redirect_to removed.subscribed
  end
end
