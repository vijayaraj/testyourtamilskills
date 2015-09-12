class UserQuestionSetsController < ApplicationController

  before_filter :set_params, :only => [:show]
  before_filter :check_status, :only => :update

  def new
    @user_question_set = scoper.new
  end

  def create
    @user_question_set = scoper.new(user_question_set_params)
    @user_question_set.status = UserQuestionSet::STATUS.invert[:in_progress]
    @user_question_set.start_time = Time.now
    @user_question_set.score = 0

    respond_to do |format|
      if @user_question_set.save
        format.html { redirect_to question_set_questions_path(@user_question_set.question_set_id) }
        format.json {}
      else
        format.html { redirect_to question_set_questions_path(@user_question_set.question_set_id) }
        format.json {}
      end
    end
  end

  def update
    @user_question_set.answers = params[:choices]
    @user_question_set.status = UserQuestionSet::STATUS.invert[:completed]
    @user_question_set.end_time = Time.now
    @user_question_set.save
    
    respond_to do |format|
      format.html { redirect_to question_set_path(@user_question_set.question_set_id) }
      format.json {}
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
      
      if @user_question_set.completed?
        flash[:notice] = I18n.t("notifications.no_access")
        redirect_to question_set_path(@user_question_set.question_set_id)
      end 
    end

end
