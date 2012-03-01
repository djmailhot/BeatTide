# Controller for managing posts, including creating and liking posts.
# 
# Author:: Alex Miller, Brett Webber, Melissa Winstanley
class PostsController < ApplicationController

  # Creates a new post belonging to the currently authenticated user.
  # Should fail if there is no user signed in.
  def create
    logger.info "Post :: Post creation request by user #{current_user.username}."
    song = Song.find_by_api_id(params[:api_id])
    if song.nil?
      render :json => "Error"
    else
      post = Post.create_from_song(song, current_user)
      render :json => post
    end
  end

  # Shows a single post. Sets the post instance variable to a post corresponding
  # to the passed ID.
  def show
    @post = Post.find(params[:id])
  end

  # Shows a single post. Sets the post instance variable to a post corresponding
  # to the passed ID. The post appears without any layout. Useful for AJAX
  # requests.
  def show_raw
    @post = Post.find(params[:id])
    render :template => "posts/show", :layout => false
  end

  # Destroys a post belonging to the currently authenticated user.
  # Should fail if there is no user signed in, or if the specified
  # post does not belong to the current user.
  def destroy
    logger.info "Post :: Post destruction request by user
                 #{current_user.username}."
  end

  # Increments the like counter of the specified post and the
  # song associated with the post for the current user.
  # Should fail if there is no user signed in.
  def like
    logger.info "Post :: Post like request by user #{current_user.username}."
    p = Post.find(params[:id])
    p.like!(current_user)
    render :text => p.like_count
  end
end
