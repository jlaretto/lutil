class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate( params[:session][:password])
      signUserIn user
      sign_in_redirect_helper root_path
    else
      flash[:error] = "Invalid name and/or password"
      render "new"
    end

  end

  def destroy
     signOut
     redirect_to root_path
  end
end
