class CategoriesController < ApplicationController
  before_action :set_selected_tab

  def show
    @category = scope.find(params[:id])
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
