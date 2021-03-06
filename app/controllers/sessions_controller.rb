# Controller for managing user sessions from login to logout. Uses the Facebook
# API to retrieve user credentials.
#
# Author:: Melissa Winstanley
class SessionsController < ApplicationController

  # Creates a new session, processing the omniauth authentication response to
  # either login an existing BeatTide user or sign up a new user. The database
  # ID of the signed-in user is stored in a global "session" variable under the
  # :user_id symbol. Redirects to the root URL. If authentication
  # is not valid, redirects to the root path with a flash error.
  def create
    logger.info "Session :: New omniauth session request."
    auth = request.env["omniauth.auth"]
    if Utility.verify_fb_auth(auth)
      user = User.find_by_facebook_id(auth["uid"]) || User.create_with_omniauth(auth)
      sign_in user
      redirect_to root_path, :notice => "Signed in!"
    else
      flash[:error] = "You tried to log in with improper authentication credentials."
      redirect_to "/error"
      logger.error "Session :: Improper authentication credentials."
    end
  end

  # Ends a session, logging out a user. Redirects to the users defaul URL. The
  # user can no longer be accessed through the "session" variable.
  def destroy
    logger.info "Session :: End omniauth session request."
    sign_out
    redirect_to root_path, :notice => "Signed out!"
  end
end
