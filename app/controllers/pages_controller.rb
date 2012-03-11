# Controller for serving up top level pages, such as the front index page.
#
# Author:: Alex Miller
class PagesController < ApplicationController

  MAX_NUMBER_POSTS = 30

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
    @page = params[:page].to_i ||= 0
    min_index = @page * MAX_NUMBER_POSTS
    max_index = (@page + 1) * MAX_NUMBER_POSTS - 1
    @feed = current_user.feed[min_index..max_index]
    @beginning = (@page == 0)
    @end = max_index >= current_user.feed.length - 1
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
