class Question < ActiveRecord::Base
  include Ratable

  belongs_to :question_set
  belongs_to :user
  has_many :ratings, class_name: :UserQuestionRating

  accepts_nested_attributes_for :ratings
  serialize :choices

  def randomized_choices
    choices = self.choices.reject(&:blank?)
    choices << answer
    choices.shuffle
  end
end
