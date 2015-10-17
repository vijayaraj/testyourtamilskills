class Question < ActiveRecord::Base
  belongs_to :question_set
  belongs_to :user

  serialize :choices

  def randomized_choices
    choices = self.choices.reject(&:blank?)
    choices << answer
    choices.shuffle
  end
end
