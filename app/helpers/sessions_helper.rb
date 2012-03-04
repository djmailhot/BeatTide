# Helper methods for the SessionsController for signin and signout
#
# Author:: Melissa Winstanley
module SessionsHelper
  # Returns the user that is logged in in the current session. If no user is
  # logged in, then returns nil
  def current_user
    if session[:user_id].nil?
      nil
    else
      User.find_by_id(session[:user_id])
    end
  end

  # Signs the given user into the session
  def sign_in(user)
    if signed_in?
      flash.now[:error] = "Session is already signed in."
      logger.error "Session :: User requested sign in when already signed in."
    else
      session[:user_id] = user.id
      logger.info "Session :: User sign in: #{user.attributes.inspect}"
    end
  end

  # Signs the current user out of the session
  def sign_out
    if signed_in?
      session[:user_id] = nil
      logger.info "Session :: User was signed out of the session."
    else
      flash.now[:error] = "Session is already signed out."
      logger.error "Session :: User requested sign out when already signed out."
    end
  end
  

  # Returns whether or not there is a user signed into the current session
  def signed_in?
    !session[:user_id].nil?
  end

  # Returns whether the given user is currently signed into this session
  def current_user?(user)
    signed_in? && user.id == session[:user_id]
  end

  # Determines whether user is signed in, and if not redirects them away
  def authenticate
    deny_access unless signed_in?
  end

  # Redirects user to the root page
  def deny_access
    flash.now[:error] = "You are not signed in to BeatTide."
    redirect_to root_path, :notice => "Please sign in to access this page."
    logger.error "Session :: User denied access.  Redirected to sign in page."
  end

end
