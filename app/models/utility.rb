module Utility
  module_function

  # Validates the authentication credentials, returning true if all necessary information
  # is available.
  def verify_fb_auth(auth)
    !(auth.blank? || auth["uid"].blank? ||
                     !auth["uid"].to_s.match(/\A\d+\Z/) ||
                     auth["info"]["first_name"].blank? ||
                     auth["info"]["last_name"].blank?)
  end

  def check_length(str, length)
    if !str.nil? && str.length > length
      str = str[0,length]
    end
    str
  end
end
