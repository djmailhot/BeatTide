class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_facebook_id(auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to users_url, :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to users_url, :notice => "Signed out!"
  end

end
