class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  # Provides access to the user who is currently logged in to the given
  # session. If no user is currently logged in, then any evaluation of
  # the current_user will result in false.
  # 
  # Author:: Melissa Winstanley
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
