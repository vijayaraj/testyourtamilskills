class UserQuestionSet < ActiveRecord::Base
  belongs_to :user
  belongs_to :question_set

  serialize :answers

  before_create :set_default_params
  before_save :calculate_score
  after_commit :update_user_scores, on: :update

  STATUS = {
    1 => :in_progress,
    2 => :completed,
    3 => :failure
  }

  scope :filter_by_category, lambda { |category_id|
    joins(:question_set).where('question_sets.category_id = ?', category_id)
  }

  scope :filter_by_level, lambda { |level_id|
    joins(:question_set).where('question_sets.level_id = ?', level_id)
  }

  scope :answered, -> { where(status: STATUS.invert[:completed])}
  scope :answered_by, lambda { |question_set_id|
    where("question_set_id = ? and status = ?",
      question_set_id, STATUS.invert[:completed])
  }

  scope :filter_by_category_and_level, lambda { |category_id, level_id|
    joins(:question_set).where('question_sets.category_id = ? &&
      question_sets.level_id = ?', category_id, level_id)
  }

  STATUS.values.each do |status_name|
    define_method %(#{status_name}?) do
      status.eql?(STATUS.invert[status_name])
    end
  end

  def answer(question)
    answers[question.id.to_s] || I18n.t('questions.not_answered')
  end

  private

  def set_default_params
    self.status = UserQuestionSet::STATUS.invert[:in_progress]
    self.start_time = Time.now
    self.score = 0
  end

  def calculate_score
    self.status = UserQuestionSet::STATUS.invert[:completed]
    self.end_time = Time.now
    self.score = 0
    (answers || {}).each do |question_id, answer|
      question = question_set.questions.find_by_id(question_id.to_i)
      if question.answer.eql?(answer)
        update_stats(question)
        self.score = self.score + 1
      end
    end
  end

  def update_user_scores
    user.update_user_scores(question_set.category)
  end

  def update_stats(question)
    question.update_attributes(
      right_answer_count: question.right_answer_count.to_i + 1)
  end
end
