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
      logger.info "Post :: Post creation request by user #{current_user.username}."
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
    logger.info "Post :: Post destruction request by user
                 #{current_user.username}."
    post = current_user.posts.find_by_id(params[:id])
    if is_valid?(post)
      post.user.unlike!(post.like_count)
      post.song.unlike!(post.like_count)
      # Destroy should remove all liking-user associations in the database

      target_id = post.id
      post.destroy
      logger.info "Post :: user #{current_user.username} destroyed " <<
                  "post #{target_id}"
    end
  end

  # Toggles likes. If the specified post is liked by the current user,
  # then it unlikes the post, song, and posting user. If the specified
  # post is not liked by the current user, then it likes the post,
  # song, and posting user. If there is no post with the given ID,
  # redirects to the error page.
  # * params[id] : the ID of the post to show
  def like
    logger.info "Post :: Post like toggle request by user #{current_user.username}."
    p = Post.find_by_id(params[:id])
    if is_valid?(p) and !p.liked_by?(current_user)
      p.like!(current_user)
    else
      p.unlike!(current_user)
    end
    render :text => p.like_count
  end

  private

  # Returns false if the specified post doesn't exist, and preps
  # an appropriate error and log message
  def is_valid?(post)
    valid = !post.nil?
    if !valid
      flash.now[:error] = "No post by specified id under the current user.";
      logger.error "Post :: No post by specified id under the current user."
    end
    return valid
  end
end
