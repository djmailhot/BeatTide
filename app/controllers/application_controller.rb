# General controller class, from which other controllers inherit
# Author:: Melissa Winstanley
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  helper_method :liked

  private

  def liked(post)
    @liked = post.liked_by?(current_user)
  end
end
