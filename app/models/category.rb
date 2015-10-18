class Category < ActiveRecord::Base
  has_many :levels
  has_many :question_sets
  has_many :user_question_sets, through: :question_sets
  has_many :user_scores
end
