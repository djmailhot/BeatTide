# Controller for managing user sessions from login to logout. Uses the Facebook
# API to retrieve user credentials.
# 
# Author:: Melissa Winstanley
class SessionsController < ApplicationController

  # Creates a new session, processing the omniauth authentication response to
  # either login an existing BeatTide user or sign up a new user. The database
  # ID of the signed-in user is stored in a global "session" variable under the
  # :user_id symbol. Redirects to the users default URL.
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_facebook_id(auth["uid"]) || User.create_with_omniauth(auth)
    sign_in user
    redirect_to users_url, :notice => "Signed in!"
  end

  # Ends a session, logging out a user. Redirects to the users defaul URL. The
  # user can no longer be accessed through the "session" variable.
  def destroy
    sign_out
    redirect_to users_url, :notice => "Signed out!"
  end
end
