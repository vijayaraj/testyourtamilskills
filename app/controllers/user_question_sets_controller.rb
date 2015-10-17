class UserQuestionSetsController < ApplicationController
  before_action :check_status, only: :update

  def new
    @user_question_set = scoper.new
  end

  def create
    @user_question_set = scoper.build(user_question_set_params)

    if @user_question_set.save
      redirect_to question_set_questions_path(
        @user_question_set.question_set_id)
    else
      redirect_to question_set_questions_path(
        @user_question_set.question_set_id)
    end
  end

  def update
    @user_question_set.answers = params[:choices]

    if @user_question_set.save
      redirect_to question_set_path(@user_question_set.question_set_id)
    else
      redirect_to question_set_path(@user_question_set.question_set_id)
    end
  end

  def show
    @user_question_set = scoper.find_by_id(params[:user_question_set_id])
  end

  private

  def scoper
    current_user.user_question_sets
  end

  def user_question_set_params
    params.permit(:user_id, :question_set_id, :score, :status,
                  :start_time, :end_time, :answers)
  end

  def check_status
    @user_question_set = scoper.find_by_id(params[:id])
    return unless @user_question_set.completed?

    flash[:notice] = I18n.t('notifications.no_access')
    redirect_to question_set_path(@user_question_set.question_set_id)
  end
end
