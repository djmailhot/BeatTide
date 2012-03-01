# Controller for managing posts, including creating and liking posts.
# No functionality of this controller can be accessed if there is no
# user logged in; otherwise, the page is redirected to the sign-in
# page.
# Author:: Alex Miller, Brett Webber, Melissa Winstanley
class PostsController < ApplicationController
  before_filter :authenticate

  # Creates a new post belonging to the currently authenticated user.
  # If the parameters are invalid, then the user is redirected to the
  # error page.
  # * params[:api_id] : the Grooveshark API ID of the song in this post
  def create
    if params.nil?
      flash[:error] = "You tried to create a post with an invalid song"
      redirect_to "/error"
    else
      song = Song.find_by_api_id(params[:api_id])
      if song.nil?
        flash[:error] = "You tried to create a post with an invalid song"
        redirect_to "/error"
      else
        post = Post.create_from_song(song, current_user)
        render :json => post
      end
    end
  end

  # Shows a single post. Sets the post instance variable to a post corresponding
  # to the passed ID. If there is no post with the given ID, then the user is
  # redireted to the error page.
  # * params[id] : the ID of the post to show
  def show
    @post = Post.find_by_id(params[:id])
    if @post.nil?
      flash[:error] = "You tried to access a post that does not exist"
      redirect_to "/error"
    end
  end

  # Shows a single post. Sets the post instance variable to a post corresponding
  # to the passed ID. The post appears without any layout. Useful for AJAX
  # requests. If there is no post with the given ID, then the user is
  # redireted to the error page.
  # * params[id] : the ID of the post to show
  def show_raw
    @post = Post.find_by_id(params[:id])
    if @post.nil?
      flash[:error] = "You tried to access a post that does not exist"
      redirect_to "/error"
    else
      render :template => "posts/show", :layout => false
    end
  end

  # Destroys a post belonging to the currently authenticated user.
  # If a post with the specified ID doesn't exist, or doesn't belong
  # to the current user, then the user is redirected to the error
  # page.
  # * params[id] : the ID of the post to show
  def destroy
  end

  # Increments the like counter of the specified post and the
  # song associated with the post for the current user.
  # If there is no post with the given ID, redirects to the
  # error page.
  # * params[id] : the ID of the post to show
  def like
    p = Post.find(params[:id])
    p.like!(current_user)
    render :text => p.like_count
  end
end
