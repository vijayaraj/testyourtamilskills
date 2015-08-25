class QuestionsController < ApplicationController
  
  before_filter :deny_access
  before_filter :admin_or_superadmin?, :set_question_set, :check_count, :except => :index
  before_filter :set_params, :time_started?, :check_question_set?, :only => :index

  def new
    @selected_tab = :new_question_set
    @question = scoper.new
  end

  def create
    @question = scoper.new(question_params)

    if @question.save
      flash[:notice] = "Done"
      redirect_to new_question_set_question_path(@question_set.id)
    else
      flash[:notice] = "Error"
      redirect_to question_set_questions_path(@question_set.id)
    end
  end

  def edit
    @question = scoper.find_by_id(params[:id])
  end

  def update
    @question = scoper.find_by_id(params[:id])

    if @question.update_attributes(question_params)
      flash[:notice] = "Done"
      redirect_to question_set_questions_path(@question_set.id)
    else
      flash[:notice] = "Error"
      redirect_to question_set_questions_path(@question_set.id)
    end
  end

  def index
    @questions = @question_set.questions
  end

  def show
    @question = scoper.find_by_id(params[:id])
    @selected_tab = :question_sets
  end

  def list
    @questions = scoper
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

    def check_question_set?
      # if current_user.published_question_sets.include?(@question_set)
      #   flash[:notice] = "No access"
      #   redirect_to root_path
      # end
    end

    def check_count
      if @question_set.questions.count >= 15
        redirect_to question_set_path(@question_set.id)
      end
    end

    def question_params
      params.require(:question).permit(:question, :answer, :choices => [])
    end
end
