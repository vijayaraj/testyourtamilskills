class QuestionSetsController < ApplicationController

  before_filter :deny_access
  before_filter :admin_or_superadmin?, :only => [:new, :create]
  before_filter :superadmin?, :only => :approve

  def new
    @selected_tab = :new_question_set
    @question_set = current_user.published_question_sets.new
  end

  def create
    @question_set = current_user.published_question_sets.new(question_set_params)
    @question_set.approved = false

    if @question_set.save
      flash[:notice] = "Done"
      redirect_to question_set_path(@question_set.id)
    else
      flash[:notice] = "Done"
      redirect_to new_question_set_path
    end
  end

  def approve
    @question_set = QuestionSet.find_by_id(params[:id])
    @question_set.approved = true

    if @question_set.save
      flash[:notice] = "Done"
      redirect_to root_path
    else
      flash[:notice] = "Error"
      redirect_to root_path
    end
  end

  def show
    @question_set = QuestionSet.find_by_id(params[:id])
    @question_set || raise(ActiveRecord::RecordNotFound)

    @category = @question_set.category
    @level = @question_set.level
    @user_question_set = User.current.user_question_sets.find_by_question_set_id(@question_set.id)
  end

  def index
    @selected_tab = :question_sets
    @question_sets = current_user.published_question_sets
  end

  private
    def question_set_params
      params.require(:question_set).permit(:name, :category_id, :level_id, :published)
    end

end
