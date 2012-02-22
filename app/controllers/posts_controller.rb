class PostsController < ApplicationController

  # Creates a new post belonging to the currently authenticated user.
  # Should fail if there is no user signed in.
  def create
  end

  # Destroys a post belonging to the currently authenticated user.
  # Should fail if there is no user signed in, or if the specified
  # post does not belong to the current user.
  def destroy
  end

  # Increments the like counter of the specified post and the
  # song associated with the post for the current user.
  # Should fail if there is no user signed in.
  def like
  end
end