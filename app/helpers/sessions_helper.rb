module SessionsHelper

  # Return whether the specified user is the current user.
  # Ruby has implicit return values.
  def current_user?(user)
    user == current_user
  end

=begin
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end
=end
end
