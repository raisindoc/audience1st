module AuthenticatedSystem
  protected

  def current_user=(new_user)
    if new_user
      session[:cid] = new_user.id
      @current_user = new_user
    else
      session[:cid] = nil
      @current_user = false
    end
  end

  # Accesses the current user from the session.
  # Future calls avoid the database because nil is not equal to false.
  def current_user
    unless @current_user == false # false means don't attempt auto login
      @current_user ||= (login_from_session || login_from_cookie)
    end
    @current_user
  end

  def create_session(u = nil)
    logout_keeping_session!
    @user = u || yield(params)
    if @user && @user.errors.empty?
      self.current_user = @user
      # 'remember me' checked?
      create_or_refresh_remember_cookie! if params[:remember_me]
      # finally: reset all store-related session state UNLESS the login
      # was performed as part of a checkout flow
      reset_shopping unless @gCheckoutInProgress
      session[:new_session] = true
      redirect_after_login(@user)
    end
  end

  def new_session?
    # returns true the FIRST time it's called on a session.  Used for
    # displaying login-time messages, etc.
    session.delete(:new_session)
  end

  private

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = Customer.find_by_id(session[:cid]) if session[:cid]
  end

  #
  # Logout
  #

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    # Kill server-side auth cookie
    @current_user = false     # not logged in, and don't do it for me
    session.delete(:cid)
    reset_shopping unless @gCheckoutInProgress
    kill_remember_cookie!     # Kill client-side auth cookie
  end
  
  # Attempt to login by an expiring token in the cookie.
  def login_from_cookie
    if ((cookie_customer_id = cookies.signed[:cid])  &&
        (user = Customer.find_by_id(cookie_customer_id)))
      self.current_user = user
      create_or_refresh_remember_cookie!
      self.current_user
    end
  end

  # Refresh the cookie auth token if it exists, create it otherwise
  def create_or_refresh_remember_cookie!
    cookies.signed[:cid] = {
      :value => current_user.id,
      :expires => 30.days.from_now
    }
  end
  
  def kill_remember_cookie!
    cookies.delete(:cid)
  end
  
end
