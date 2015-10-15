class SessionsController < ApplicationController
 
  def new

  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      # create token and put into database
      remember(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def delete
    log_out if logged_in?
    redirect_to root_url
  end

end

