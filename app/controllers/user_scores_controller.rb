class UserScoresController < ApplicationController
  before_action :set_tab, only: :index
  
  def index
    @user_scores = Category.includes(:levels).all.inject({}) do |h, category|
      h[category.id] = UserScore.top_n_by_category(category, 10); h
    end
  end

  private

  def set_tab
    @selected_tab = :user_scores
  end
end
