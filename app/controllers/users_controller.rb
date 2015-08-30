class UsersController < ApplicationController
  before_action :authenticate_user!, :only => :show
  
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
