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

  def show
    @user = User.find(params[:id])
    @post = Post.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

end
