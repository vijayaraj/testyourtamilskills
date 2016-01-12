class QuestionsController < ApplicationController
  before_action :set_published_question_set,
                :set_question_sets_tab, except: [:index, :rate]
  before_action :can_add?, only: [:new, :create, :show]
  before_action :can_edit?, :load_question, only: [:edit, :update]

  before_action :set_answered_question_set, :can_rate?,
                :load_question, only: :rate
  before_action :set_question_set_params, :time_started?, only: :index

  def new
    @question = scoper.new
  end

  def create
    @question = scoper.build(question_params)

    if @question.save
      redirect_to new_question_set_question_path(@question_set.id),
                  notice: I18n.t('notifications.success')
    else
      redirect_to question_set_questions_path(@question_set.id), flash: {
        error: I18n.t('notifications.error') }
    end
  end

  def edit
  end

  def update
    if @question.update_attributes(question_params)
      redirect_to question_set_path(@question_set.id),
                  notice: I18n.t('notifications.success')
    else
      redirect_to question_set_path(@question_set.id), flash: {
        error: I18n.t('notifications.error') }
    end
  end

  def index
    @questions = @question_set.questions
  end

  def show
    @question = scoper.find_by_id(params[:id])
    @selected_tab = :question_sets
  end

  def rate
    if @question.update_attributes(rating_params)
      redirect_to question_set_path(@question_set.id),
                  notice: I18n.t('notifications.success')
    else
      redirect_to question_set_path(@question_set.id),
                  flash: { error: I18n.t('notifications.error') }
    end
  end

  private

  def set_published_question_set
    @question_set = current_user.published_question_sets.find(
      params[:question_set_id])
  end

  def set_answered_question_set
    @question_set = current_user.answered_question_sets.find(
      params[:question_set_id])
  end

  def scoper
    @question_set.questions
  end

  def question_set_scoper
    current_user.enduser? ? QuestionSet.approved : QuestionSet
  end

  def load_question
    @question = scoper.find(params[:id])
  end

  def can_add?
    return unless @question_set.questions.count >= 15

    flash[:notice] = I18n.t('notifications.question_limit_reached')
    redirect_to question_set_path(@question_set.id)
  end

  def can_edit?
    return unless @question_set.owner?(current_user)

    flash[:notice] = I18n.t('notifications.question_set_published')
    redirect_to question_set_path(@question_set.id)
  end

  def can_rate?
    return unless @question_set.owner?(current_user)

    flash[:notice] = I18n.t('notifications.owner_cannot_rate')
    redirect_to question_set_path(@question_set.id)
  end

  def time_started?
    return if current_user.published_question_sets.include?(@question_set)
    return if @user_question_set && @user_question_set.start_time

    flash[:notice] = 'No access'
    redirect_to root_path
  end

  def question_params
    params.require(:question).permit(:question, :answer, choices: [])
  end

  def set_question_set_params
    @question_set = question_set_scoper.find(params[:question_set_id])
    @user_question_set = current_user.user_question_sets.where(question_set_id:
      @question_set.id).first
    @selected_tab = %(category_#{@question_set.category.id})
  end

  def rating_params
    rating_params = params.require(:question).permit(
      :id,
      ratings_attributes: [:id, :user_id, :rating, :feedback]
    )
    # Temporary hack for AJAX param setting
    if rating_params[:ratings_attributes].is_a? Hash
      rating_params[:ratings_attributes] =
          [rating_params[:ratings_attributes]['0']]
    end
    rating_params[:ratings_attributes][0][:user_id] = current_user.id
    rating_params
  end

  def set_question_sets_tab
    @selected_tab = :question_sets
  end
end
