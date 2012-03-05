# Controller for serving up top level pages, such as the front index page.
#
# Author::   Alex Miller
class PagesController < ApplicationController
  # Displays an index page for the entire site.
  def index
  end

  # Sets the user's paginated feed to @feed
  def feed
    page = params[:page] ||= 1
    @feed = current_user.feed.paginate(:page => page, :per_page => 50)
    render "feed"
  end

  def error
    @error = flash[:error]
    if @error.nil?
      @error = "No errors! You have reached this page in error."
    end
  end
end
