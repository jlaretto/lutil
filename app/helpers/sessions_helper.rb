module SessionsHelper

  def signUserIn (user)
      user.save!
      cookies["session_token"] = {value: user.session_token, expires: Time.now + 3600 }
  end

  def signOut
      cookies["session_token"] = nil
      @current_user = nil
  end

  def current_user
    @current_user ||= loadCurrentUser()
  end

  def loadCurrentUser
    @current_user = User.find_by_session_token(cookies[:session_token])
  end

  def sign_in_redirect_helper (path)
    if session[:forwardURL].present?
       #forward to the previously requested URL
      redirect_to session[:forwardURL]
      session.delete(:forwardURL)
    else

      if current_user.person.nil?
        redirect_to after_signup_wizard_path(:company_details)
      else
        redirect_to path
      end
    end
  end

  def userSignedIn?
    !current_user.nil?
  end

  def redirect_if_not_signed_in
    if current_user.nil?
      session[:forwardURL] = request.fullpath
      redirect_to signin_path
    else
      updateSessionCookie
    end

#     redirect_to signin_path unless !current_user.nil?
  end

  def updateSessionCookie
    cookies["session_token"] = {value: current_user.session_token, expires: Time.now + 3600 }
  end

end
