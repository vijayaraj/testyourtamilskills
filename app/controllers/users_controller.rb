class UsersController < ApplicationController
  skip_before_action :deny_access, only: :home

  def home
    @selected_tab = :rules
  end

  def destroy
    sign_out current_user
    redirect_to root_path
  end
end
