class LevelsController < ApplicationController
  
  def show
    @level = Level.find_by_id(params[:id])
    @category = @level.category
    @question_sets = question_sets_scoper.paginate(:page => params[:page],:per_page => 10)

    @selected_tab = %(category_#{@category.id})
  end

  private
    def question_sets_scoper
      @level.question_sets.approved.not_self(current_user.id).oldest
    end

end
