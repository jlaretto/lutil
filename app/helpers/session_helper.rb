module SessionHelper


  def current_user
    @current_user ||= loadCurrentUser()
  end

  def loadCurrentUser
    @current_user = User.find_by_session_token(cookies[:session_token])
  end

end
