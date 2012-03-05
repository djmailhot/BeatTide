

# Manages operations involving interactions between the views
# and models regarding the users. Supports listing all users,
# creating users, and showing and editing specific users.
#
# Author:: David Mailhot, Tyler Rigsby, Brett Webber
class UsersController < ApplicationController
  POSTS_PER_PAGE = 50

  before_filter :authenticate

  # Sets @users to a list of all the users and @title
  # to "All users"
  def index
    @users = User.all
    @title = "All users"
  end

  # Accepts the user's information in params[:user] and
  # creates and saves a new user with the information
  def create
    logger.info "User :: User creation request"
    @user = User.new(params[:user])
    if @user.valid?
      @user.save
    else
      flash.now[:error] = "Invalid user information."
    end
  end

  # Sets the user specified in params[:id] to @user and
  # responds to requests for a the specified user's information
  def show
    @user = User.find_by_id(params[:id])
    if @user.nil?
      flash[:error] = "No such user exists."
      redirect_to "/error"
    else
      logger.info "User :: User show info request for user #{@user.username}"
      page = params[:page] ||= 1
      @posts = @user.posts.paginate(:page => page, :per_page => POSTS_PER_PAGE)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # Initializes the editing of a user by setting @user to the
  # specified user. Allows user to edit their profile.
  def edit
    @user = current_user
    logger.info "User :: User edit request for user #{@user.username}"
  end

  # Updates the user's attributes based on the user parameter, then
  # redirects to the edit action.
  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = "Your profile was updated!"
      redirect_to :action => "edit"
    else
      flash[:notice] = "Please make sure you fill out the required fields, marked with asterisks."
      redirect_to :action => "edit"
    end
  end

  # Search for a user based on the :query parameter
  def find_user
    logger.info "User :: User search request initiated."
    logger.info "User :: User query #{params[:query]}"
    if !params[:query].empty?
      @results = User.search(params[:query]);

      # If there are no results
      if @results.empty?
        render :text => "No results found :("
      else
        @results = sortUsersByRelevancy(params[:query])
        render :partial => "users/user_list", :locals => {:users => @results}, :layout => false
      end
    else
      render :text => "Please enter a query."
    end
  end

  private

  def right_user
    @user = User.find_by_id(params[:id])
    if @user.nil? || !current_user?(@user)
      flash[:error] = "Cannot access page: you are not the right user."
      redirect_to "/error"
    end
  end

  # This method sorts a list of users by relevancy to the search query
  #     @results is the array of users returned by the sql query
  def sortUsersByRelevancy(query)
    results = Hash.new
    @results.each do |user|
      results[user] = editDistance(user, query)
    end

    # Sort the hash.  This returns a 2D array
    twoDResults = results.sort {|a,b| a[1] <=> b[1]}

    # Return an array of users in the sorted order
    sortedResults = Array.new
    twoDResults.each do |user, count| 
      sortedResults << user
    end
    return sortedResults
  end




  # Takes a user and a search query.  Compares the search query to the users name
  # and returns the edit difference
  def editDistance(user, query)
    words = query.split(" ")
    words.each do |search|
      a = calculateEditDistance(search, user.first_name, 0, 0, false)
      b = calculateEditDistance(search, user.last_name, 0, 0, false)
      c = calculateEditDistance(search, user.username, 0, 0, false)
      return [a, b, c].min
    end
  end

  # Calculate the edit distance between two strings (query and name)
  # indexQuery represents what index we're at for query
  # indexName represents what index we're at for name
  # match is a boolean initially set to false.  It is set to true if we have
  #   found at least one matching letter.  This prevents us from favoring
  #   short names with no letters in common over long names with letters
  #   in common.  (Eg: Yi and Miller in a search for e)
  def calculateEditDistance(query, name, indexQuery, indexName, match)
    if indexQuery == query.length && indexName == name.length
      return 0 + multiplier(match)
    elsif indexQuery == query.length
      return multiplier(match) + name.length - indexName
    elsif indexName == name.length
      return multiplier(match) + query.length - indexQuery

    # If the letters match, change match to true to indicate we found at least one matching letter
    elsif query[indexQuery].casecmp(name[indexName]) == 0
      return calculateEditDistance(query, name, indexQuery + 1, indexName + 1, true)
    else

      # Delete a character from the name
      del = calculateEditDistance(query, name, indexQuery + 1, indexName, match)

      # Insert a character into the query
      insert = calculateEditDistance(query, name, indexQuery, indexName + 1, match)

      # Swap two characters
      swap = calculateEditDistance(query, name, indexQuery + 1, indexName + 1, match)

      return 1 + [del, insert, swap].min
    end
  end


  # Match is a boolean which indicates if any character matched the query.  
  # If no characters matched we want to indicate this is a bad edit difference
  #   so we add 100 to weigh it down.  
  #   This prevents short names from being rated as good matches
  def multiplier(match)
    if(match)
      return 0
    end
    100
  end
    
end
