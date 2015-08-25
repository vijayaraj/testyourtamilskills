class User < ActiveRecord::Base
  
  ROLES = {
    1 => :superadmin,
    2 => :admin,
    3 => :enduser
  }

  BADGES = [:rookie, :apprentice, :assasin, :master, :god]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  has_many :identities

  # has_and_belongs_to_many :achieved_levels,
  #   :class_name => "Level",
  #   :join_table => "user_levels", 
  #   :autosave => true
  
  has_many :published_question_sets,
    :class_name => "QuestionSet"
  
  has_many :user_question_sets
  has_many :answered_question_sets,
    :through => "user_question_sets",
    :class_name => "QuestionSet",
    :source => "question_set"

  
  def self.current
    Thread.current[:user]
  end

  def self.reset_current_account
    Thread.current[:user] = nil
  end

  def set_current
    Thread.current[:user] = self
  end

  ROLES.each do |r_id, role|
    define_method "#{role}?" do
      role_id.eql?(r_id)
    end
  end

  def score(category, level)
    question_sets = level.question_sets.filter_by_category(category.id)
    question_sets.map(&:score).max
  end

  def filter_user_question_sets(category, level)
    user_question_sets.select{ 
      |uqs| uqs.question_set.category_id.eql?(category.id) and uqs.question_set.level_id.eql?(level.id) }
  end

  def score(category, level)
    filter_user_question_sets(category, level).map(&:score).max
  end

  def user_question_set(question_set)
    user_question_sets.find_by_question_set_id(question_set.id)
  end

  def question_set_score(question_set)
    user_question_set(question_set) ? user_question_set(question_set).score : 0
  end

  def question_set_status(question_set)
    user_question_set(question_set).status if user_question_set(question_set)
  end

  def badge(category)
    case points(category)
    when 0..25 then BADGES[0]
    when 26..40 then BADGES[1]
    when 41..50 then BADGES[2]
    when 51..64 then BADGES[3]
    when 65..75 then BADGES[4]
    end
  end

  def points(category)
    points = 0
    category.levels.map{ |level| points = points + score(category, level).to_i }
    points
  end

  
end
