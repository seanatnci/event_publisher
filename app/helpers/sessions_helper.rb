module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.password_salt]
    self.current_user = user
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  def routing_error(organizer)
    redirect_to edit_organizer_path(organizer), :notice => "Routing error: not allowed access to that resource."
  end
  def current_user=(user)
    @current_user = user
  end
  def current_user
    @current_user ||= user_from_remember_token
  end
  def signed_in?
    !current_user.nil?
  end
  def signed_in_as_different_user?(organizer)
    !current_user.id == organizer
  end
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
