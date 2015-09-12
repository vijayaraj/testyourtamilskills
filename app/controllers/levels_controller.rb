class LevelsController < ApplicationController

  before_filter :set_params, :only => :show
  
  def show
    @question_sets = @level.question_sets.approved.not_self(current_user.id).
      filter_by_category(@category.id).paginate(:page => params[:page],:per_page => 4)
  end

  private
    def set_params
      @level = Level.find_by_id(params[:id])
      @category = @level.category
      @selected_tab = %(category_#{@category.id})
    end

end
