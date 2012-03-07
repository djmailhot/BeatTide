# Helper functions for application views.
#
# Author:: Alex Miller
module ApplicationHelper
  
  # Like the Rails provided "link_to" function, but allows the link to load
  # the new content without the page reloading. This means that the user's
  # music doesn't stop playing.
  def ajax_link_to(body, options, html_options = {})
    url = url_for(options)
    # remove leading slash. so the path plays nicely with the PathJS lib
    url[0] = "" if url[0] == "/"
    url = "#!/" + url
    html_options[:class] = "ajax-link"
    link_to body, url, html_options
  end
end
