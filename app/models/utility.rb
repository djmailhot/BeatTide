# Provides utility functions for dealing with input validation
# Author:: Melissa Winstanley
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

  # Checks that the given string is no longer than the given length. If
  # it is longer, returns the string truncated to the given length;
  # otherwise returns the orginal string
  def check_length(str, length)
    if !str.nil? && str.length > length
      str = str[0,length]
    end
    str
  end
end
