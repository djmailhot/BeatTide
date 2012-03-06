# Base class for all controllers. Contains functionality inherent to all controllers
# in the app.
#
# Author::   Melissa Winstanley, Alex Miller
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Every single action should set the raw instance variable.
  before_filter :set_raw
  
  include SessionsHelper

  helper_method :liked

  private

  def liked(post)
    @liked = post.liked_by?(current_user)
  end
  
  # Sets the "raw" instance variable to mirror the raw parameter passed in.
  # This is useful because when an AJAX request is made, the raw parameter
  # will be set to true. This acts as a flag for the application layout to
  # render the view without the surrounding header and HTML tags. This allows
  # for content to be injected into the page without duplicating the header and
  # other stuff.
  def set_raw
    @raw = params[:raw]
  end
end
