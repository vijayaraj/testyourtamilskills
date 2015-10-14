class QuestionsController < ApplicationController
  
  before_filter :set_question_set, :set_question_sets_tab, :except => :index
  before_filter :can_add?, only: [:new, :create, :show]
  before_filter :can_edit?, only: [:edit, :update]
  before_filter :set_params, :time_started?, :only => :index

  def new
    @question = scoper.new
  end

  def create
    @question = scoper.new(question_params)

    if @question.save
      flash[:notice] = I18n.t("notifications.success")
      redirect_to new_question_set_question_path(@question_set.id)
    else
      flash[:notice] = I18n.t("notifications.error")
      redirect_to question_set_questions_path(@question_set.id)
    end
  end

  def edit
    @question = scoper.find_by_id(params[:id])
  end

  def update
    @question = scoper.find_by_id(params[:id])

    if @question.update_attributes(question_params)
      flash[:notice] = I18n.t("notifications.success")
      redirect_to question_set_path(@question_set.id)
    else
      flash[:notice] = I18n.t("notifications.error")
      redirect_to question_set_path(@question_set.id)
    end
  end

  def index
    @questions = @question_set.questions
  end

  def show
    @question = scoper.find_by_id(params[:id])
    @selected_tab = :question_sets
  end

  private
    def set_question_set
      @question_set = current_user.published_question_sets.find_by_id(params[:question_set_id])
      @question_set || raise(ActiveRecord::RecordNotFound)
    end

    def scoper
      @question_set.questions
    end

    def index_scoper
      current_user.enduser? ? QuestionSet.approved : QuestionSet
    end

    def set_params
      @question_set = index_scoper.find_by_id(params[:question_set_id])
      @question_set || raise(ActiveRecord::RecordNotFound)
      
      @user_question_set = current_user.user_question_sets.
                find_by_question_set_id(@question_set.id)
      @category = @question_set.category
      @level = @question_set.level
      
      @selected_tab = %(category_#{@category.id})
    end

    def time_started?
      return if current_user.published_question_sets.include?(@question_set)
      
      unless @user_question_set and @user_question_set.start_time
        flash[:notice] = "No access"
        redirect_to root_path
      end
    end

    def can_add?
      if @question_set.questions.count >= 2
        flash[:notice] = I18n.t("notifications.question_limit_reached")
        redirect_to question_set_path(@question_set.id)
      end
    end

    def can_edit?
      if @question_set.approved
        flash[:notice] = I18n.t("notifications.question_set_published")
        redirect_to question_set_path(@question_set.id)
      end
    end

    def question_params
      params.require(:question).permit(:question, :answer, :choices => [])
    end

    def set_question_sets_tab
      @selected_tab = :question_sets
    end
end
