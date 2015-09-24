class QuestionSet < ActiveRecord::Base

  belongs_to :category
  belongs_to :level
  belongs_to :owner, :class_name => "User", :foreign_key => :user_id
  has_many :questions
  has_many :user_question_sets
  has_many :users, :through => "user_question_sets"

  scope :approved, -> { where("approved is true") }
  scope :not_self, -> (user_id) { where("user_id <> #{user_id}") }
  scope :newest, -> { order("created_at desc") }
  scope :oldest, -> { order("created_at") }

  def owner?(user)
    owner.eql?(user)
  end

  def approved?
    approved.eql?(true)
  end

end
