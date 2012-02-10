class UsersController < ApplicationController

  def index
    @users = User.all
    @title = "All users"
  end

  def new
    @user = User.new
    @title = "New User"
  end

  def create
    @user = User.new(params[:user])
    @user.save
  end

end
