class CategoriesController < ApplicationController
  
  before_filter :set_selected_tab

  def show
    @category = scope.find_by_id(params[:id])
    @category || raise(ActiveRecord::RecordNotFound)
    @levels = @category.levels.all.order(:rank) 
  end

  private
    def scope
      Category
    end

    def set_selected_tab
      @selected_tab = %(category_#{params[:id]})
    end
end
