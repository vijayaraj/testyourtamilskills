class QuestionSet < ActiveRecord::Base

  belongs_to :category
  belongs_to :level
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :questions

  has_many :user_question_sets
  has_many :users, :through => "user_question_sets"

  scope :approved, -> { where("approved is true") }
  scope :not_self, -> (user_id) { where("user_id <> #{user_id}") }
  
  scope :filter_by_category, -> (category_id) { where("category_id = ?", category_id) }
  scope :filter_by_level, -> (level_id) { where("level_id = ?", level_id) }
  scope :filter_by_category_and_level, -> (category_id, level_id) do
    where('category_id = ? and level_id = ?', category_id, level_id)
  end

  def owner?(user)
    owner.eql?(user)
  end

  def approved?
    approved.eql?(true)
  end

end
