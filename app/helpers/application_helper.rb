module ApplicationHelper
  def ajax_link_to(body, base_url, html_options = {}, params = "")
    url = base_url + "?raw=true&" + params
    link_to body, url, html_options
  end
end
