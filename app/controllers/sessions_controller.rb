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
    if validate_auth(auth)
      user = User.find_by_facebook_id(auth["uid"]) || User.create_with_omniauth(auth)
      sign_in user
      redirect_to root_path, :notice => "Signed in!"
    else
      flash.now[:error] = "Improper authentication credentials."
      redirect_to root_path, notice => "Improper authentication."
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

  private

  # Validates the authentication credentials, returning true if all necessary information
  # is available.
  def validate_auth(auth)
    !(auth.blank? || auth["uid"].blank? ||
                     !auth["uid"].to_s.match(/\A\d+\Z/) ||
                     auth["info"]["first_name"].blank? ||
                     auth["info"]["last_name"].blank?)
  end
end
