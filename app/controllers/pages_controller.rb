# Controller for serving up top level pages, such as the front index page.
#
# Author:: Alex Miller
class PagesController < ApplicationController

  FEED_POSTS_PER_PAGE = 50
  
  # Displays an index page for the entire site.
  def index
  end
  
  # Displays the frequently asked questions page.
  def faq
  end
  
  # Displays the about BeatTide page
  def about
  end

  # Displays the tutorial page
  def tutorial
  end

  # Sets the user's paginated feed to @feed
  def feed
    page = params[:page] ||= 1
    @feed = current_user.feed.paginate(:page => page, :per_page => FEED_POSTS_PER_PAGE)
    render "feed"
  end

  # Displays an error saved in the flash[:error] variable
  def error
    @error = flash[:error]
    if @error.nil?
      @error = "No errors! You have reached this page in error."
    end
  end
end
