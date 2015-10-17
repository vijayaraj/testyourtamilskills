class User < ActiveRecord::Base
  ROLES = {
    1 => :superadmin,
    2 => :admin,
    3 => :enduser
  }

  BADGES = {
    rookie: 0..25,
    apprentice: 26..40,
    scholar: 41..50,
    master: 51..64,
    god: 65..75
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :identities
  has_many :published_question_sets,
           class_name: 'QuestionSet'
  has_many :user_question_sets
  has_many :answered_question_sets, through: 'user_question_sets',
                                    class_name: 'QuestionSet',
                                    source: 'question_set'

  def self.current
    Thread.current[:user]
  end

  def set_current
    Thread.current[:user] = self
  end

  ROLES.each do |r_id, role|
    define_method %(#{role}?) do
      role_id.eql?(r_id)
    end
  end

  def filter_user_question_sets(category, level)
    user_question_sets.select do |uqs|
      uqs.question_set.category_id.eql?(category.id) &&
        uqs.question_set.level_id.eql?(level.id)
    end
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
    BADGES.each_pair do |badge, score|
      eligible = points(category) > 0 && score.to_a.include?(points(category))
      return badge if eligible
    end
    nil
  end

  def points(category)
    points = 0
    category.levels.map { |level| points += score(category, level).to_i }
    points
  end
end
