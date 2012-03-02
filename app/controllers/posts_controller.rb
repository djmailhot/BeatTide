# Controller for managing posts, including creating and liking posts.
# 
# Author:: Alex Miller, Brett Webber, Melissa Winstanley
class PostsController < ApplicationController

  # Creates a new post belonging to the currently authenticated user.
  # Should fail if there is no user signed in.
  def create
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
  end

  # Toggles likes. If the specified post is liked by the current user,
  # then it unlikes the post, song, and posting user. If the specified
  # post is not liked by the current user, then it likes the post,
  # song, and posting user. Does nothing if no user is signed in.
  def like
    if (signed_in?)
      p = Post.find(params[:id])
      if !p.liked_by?(current_user)
        p.like!(current_user)
      else
        p.unlike!(current_user)
      end
      render :text => p.like_count
    end
  end

end
