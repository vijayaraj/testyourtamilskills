class QuestionSetsController < ApplicationController
  before_action :check_superadmin_privileges, only: :approve
  before_action :load_question_set, :set_selected_tab, only: [:show, :approve]

  def new
    @selected_tab = :question_sets
    @question_set = scoper.new
  end

  def create
    @question_set = scoper.build(question_set_params)
    @question_set.approved = false

    if @question_set.save
      redirect_to question_set_path(@question_set.id),
                  notice: I18n.t('notifications.success')
    else
      redirect_to new_question_set_path, flash: {
        error: I18n.t('notifications.error') }
    end
  end

  def approve
    @question_set.approved = true

    if @question_set.save
      flash[:notice] = 'Done'
      redirect_to root_path
    else
      flash[:notice] = 'Error'
      redirect_to root_path
    end
  end

  def show
    @questions = @question_set.questions.paginate(
      page: params[:page], per_page: 5)
    @user_question_set = current_user.user_question_sets.where(question_set_id:
      @question_set.id).first
  end

  def index
    @selected_tab = :question_sets
    @question_sets = scoper.newest.paginate(page: params[:page], per_page: 10)
  end

  private

  def scoper
    current_user.published_question_sets
  end

  def load_question_set
    @question_set = QuestionSet.find(params[:id])
  end

  def question_set_params
    params.require(:question_set).permit(:name, :category_id, :level_id,
                                         :published)
  end

  def set_selected_tab
    if @question_set.owner?(current_user)
      @selected_tab = :question_sets
    else
      @selected_tab = %(category_#{@question_set.category.id})
    end
  end
end
