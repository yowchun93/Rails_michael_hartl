module SessionsHelper

  # def log_in(user)
  #   session[:user_id] = user.id 
  # end
  def log_in(user)
    session[:user_id] = user.id
  end

  # current_user 
  def current_user
    # if session[:user_id] exist, (set user_id to session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      # raise # The test still pass, so this branch is currently untested.
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end
  #1.create a random string of digits for use as remembe rtoken 
  #2.place the token in the cookies with expiration date 
  #3.save the hash digest of the token to database 
  #4.place encrypted version of user id in browser cookies
  # to make sure of security
  #5. when presented with cookie containing persisten user id ,
  # find th database using given id, verify 
  # remember token matches hash digest from database 
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token  
  end

  def current_user?(user)
    user == current_user
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # if current user is not nil
  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # destroy 
  def destroy
    log_out 
    redirect_to root_url
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
