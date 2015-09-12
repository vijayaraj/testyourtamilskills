class UsersController < ApplicationController
  skip_before_action :deny_access, :only => :home
  
  def show
  end

  def home
    @selected_tab = :rules
  end

  private
    def scoper
      @user = User.find(params[:id])
    end
end
