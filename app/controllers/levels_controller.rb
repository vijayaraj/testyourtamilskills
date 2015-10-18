class LevelsController < ApplicationController
  before_action :load_params, :set_selected_tab, only: :show

  def show
    @question_sets = question_sets_scoper.includes(:owner).paginate(
      page: params[:page], per_page: 10)
  end

  private

  def load_params
    @level = Level.find_by_id(params[:id])
    @category = @level.category
  end

  def set_selected_tab
    @selected_tab = %(category_#{@category.id})
  end

  def question_sets_scoper
    @level.question_sets.approved.not_self(current_user.id).oldest
  end
end
