# Helper functions for application views.
#
# Author:: Alex Miller
module ApplicationHelper
  
  # Like the Rails provided "link_to" function, but allows the link to load
  # the new content without the page reloading. This means that the user's
  # music doesn't stop playing.
  def ajax_link_to(body, options, html_options = {})
    html_options[:remote] = true
    html_options[:class] = "ajax-link"
    link_to body, options, html_options
  end
end
