class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:notice] }
  before_filter -> { flash.now[:error] = flash[:error].html_safe if flash[:error] }

  helper_method :current_user_session, :current_user, :admin_or_superadmin?
  before_filter :unset_current_user, :set_current_user
  before_filter :deny_access

  # Login check
  def deny_access
    unless authorized?
      flash[:error] = I18n.t("notifications.login_to_access")
      redirect_to root_path 
    end
  end

  def authorized?
    current_user
  end

  # Privilege checks
  def access_denied
    flash[:error] = I18n.t("notifications.no_access")
    redirect_to root_path 
  end

  def check_admin_or_superadmin_privileges
    access_denied unless admin_or_superadmin?
  end

  def check_superadmin_privileges
    access_denied unless superadmin?
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

  private
    def unset_current_user
      Thread.current[:user] = nil
    end

    def set_current_user
      current_user.set_current if current_user
    end

end
