class UserQuestionSet < ActiveRecord::Base

  belongs_to :user
  belongs_to :question_set

  serialize :answers

  after_update :calculate_score

  STATUS = {
    1 => :in_progress,
    2 => :success,
    3 => :failure
  }

  scope :filter_by_category, -> (category_id) do
    joins(:question_set).where("question_sets.category_id = #{category_id}")
  end

  scope :filter_by_level, -> (level_id) do
    joins(:question_set).where("question_sets.level_id = #{level_id}")
  end

  scope :filter_by_category_and_level, -> (category_id, level_id) do
    joins(:question_set).where(
      "question_sets.category_id = #{category_id} and question_sets.level_id = #{level_id}")
  end
  

  def in_progress?
    status.eql?(STATUS.invert[:in_progress])
  end

  def completed?
    status.eql?(STATUS.invert[:success])
  end

  private
    def calculate_score
      score = 0
      answers.each do |question_id, answer|
        question = question_set.questions.find_by_id(question_id)
        score = question.answer.eql?(answer) ? score + 1 : score - 1
      end    
      self.update_column(:score, score)
    end

end
