# Controller for creating/managing subscriptions. Contains
# functions for indexing as well as creating/destroying
# subscriptions.
#
# Author:: Tyler Rigsby (mailto: rigsbyt@cs.uw.edu)
class SubscriptionsController < ApplicationController
  before_filter :authenticate

  # Show all the users the current user is subscribed to.
  # Sets @subscriptions to the list of subscriptions
  def index
    @subscriptions = current_user.subscriptions
  end

  # creates a subscription from the current user to
  # params[:subscription][:subscribed_id]
  # redirects the user back to the page of the subscribed user
  def create
    @them = User.find(params[:id])
    logger.info "Subscription :: Subscription creation request by user " <<
                "#{current_user.username}"
    if @them.nil?
      flash.now[:error] = "The specified user doesn't exist";
      logger.error "Subscription :: target user doesn't exist."
    elsif current_user == @them
      flash.now[:error] = "Cannot subscribe to yourself";
      logger.error "Subscription :: target user #{@them.username} was current user."
    elsif current_user.subscribing?(@them)
      flash.now[:error] = "You are already subscribed to this user";
      logger.error "Subscription :: target user #{@them.username} already " <<
                   "subscribed to"
    else
      current_user.subscribe!(@them)
      logger.info "Subscription :: user #{current_user.username} created " <<
                  "subscription to user #{@them.username}"
      respond_to do |fmt|
        fmt.html {redirect_to @them}
        fmt.js
      end
    end
  end

  # destroys a subscription based on its subscription_id
  # redirects the user to the page of the user it was looking at
  def destroy
    logger.info "Subscription :: Subscription destruction request by user " <<
                "#{current_user.username}"
    subscription = current_user.subscriptions.find_by_subscribed_id(params[:id])
    if subscription.nil?
      flash.now[:error] = "Subscription doesn't exist";
      logger.error "Subscription :: target subscription doesn't exist."
    else
      target_user = subscription.subscribed
      subscription.destroy
      logger.info "Subscription :: user #{current_user.username} destroyed " <<
                  "subscription to user #{target_user.username}"
    end
    respond_to do |fmt|
      fmt.js
    end
  end
end
