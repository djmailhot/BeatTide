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
    session[:user_id] = user.id
  end

  # Signs the current user out of the session
  def sign_out
    session[:user_id] = nil
  end

  # Returns whether or not there is a user signed into the current session
  def signed_in?
    !session[:user_id].nil?
  end

  # Returns whether the given user is currently signed into this session
  def current_user?(user)
    user.id == session[:user_id]
  end
end
