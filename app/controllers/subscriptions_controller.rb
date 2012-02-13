class SubscriptionsController < ApplicationController

  def index
    @subscriptions = Subscription.all
    @title = "All subscriptions"
  end

  def create
    @me = User.find(session[:user_id])
    @them = User.find(params[:user])
    if @me != @them
      @me.subscribe!(@them)
    end
      
  end

  def destroy
    Subscription.find(params[:id]).destroy
  end
end
