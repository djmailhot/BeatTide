# Manages operations involving interactions between the views
# and models regarding the users. Supports listing all users,
# creating users, and showing and editing specific users.
#
# Author:: David Mailhot, Tyler Rigsby, Brett Webber
class UsersController < ApplicationController
  before_filter :authenticate

  # Sets @users to a list of all the users and @title
  # to "All users"
  def index
    @users = User.all
    @title = "All users"
  end

  # Initiates the creation of a new user by creating a new
  # User as @user and sets the page title to "New User"
  def new
    @user = User.new
    @title = "New User"
  end

  # Accepts the user's information in params[:user] and
  # creates and saves a new user with the information
  def create
    @user = User.new(params[:user])
    @user.save
  end

  # Sets the user specified in params[:id] to @user and
  # responds to requests for a the specified user's information
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # Initializes the editing of a user by setting @user to the
  # specified user.
  def edit
    @user = User.find(params[:id])
  end

  # Search for a user based on the :query parameter
  def find_user
    if !params[:query].empty?
      @results = User.search(params[:query]);
      render :partial => "users/user_list", :locals => {:users => @results}, :layout => false
    else
      render :text => "Please enter a query."
    end
  end
    

    # If we were passed a query
#    if !params[:query].empty?
      # This calls the solr search method
#      @search = User.search do
#        fulltext params[:query]
#      end
#      @results = @search.results
      # If we found no results print an error
#      if @results.empty?
#        render :text => "No Results Found =("
#      else
#        render 'users/user_list', :layout => false
#      end
    # If no query is passed
#    else
#      render :text => "No query."
#    end

end
