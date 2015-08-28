class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  helper_method :current_user_session, :current_user, :admin_or_superadmin?
  before_filter :unset_current_user, :set_current_user

  def deny_access
    access_denied unless authorized?
  end

  def access_denied
    flash[:error] = "You are not allowed to access this page."
    redirect_to root_path 
  end

  def check_admin_or_superadmin_privileges
    access_denied unless admin_or_superadmin?
  end

  def check_superadmin_privileges
    access_denied unless superadmin?
  end

  def authorized?
    current_user
  end

  def admin_or_superadmin?
    admin? or superadmin?
  end

  def admin?
    current_user and current_user.admin?
  end

  def superadmin?
    current_user and current_user.superadmin?
  end

  # def require_no_user
  #   if current_user
  #     store_location
  #     redirect_to root_path
  #     return false
  #   end
  # end

  # def store_location
  #   session[:return_to] = request.fullpath
  # end

  def unset_current_user
    Thread.current[:user] = nil
  end

  def set_current_user
    current_user.set_current if current_user
  end
end
