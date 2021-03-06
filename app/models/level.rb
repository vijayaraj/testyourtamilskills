class Level < ActiveRecord::Base
  has_and_belongs_to_many :user, class_name: 'User',
                                 join_table: 'user_levels',
                                 autosave: true
  belongs_to :category
  has_many :question_sets
  has_many :user_question_sets, through: :question_sets

  scope :filter_by_category, lambda { |category_id|
    where('user_levels.category_id = ?', category_id)
  }

  def previous_level
    return nil if rank.eql?(1)
    category.levels.find_by_rank(rank - 1)
  end

  def previous_level_completed?
    return true unless previous_level
    uqs = previous_level.user_question_sets.where(
      'user_question_sets.user_id = ?', User.current.id)
    uqs.present? && (uqs.select(&:completed?)).present? ? true : false
  end
end
