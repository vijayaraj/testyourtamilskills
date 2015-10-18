class UserScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  scope :top_n_by_category, lambda { |category_id, n|
    includes(:user).where('category_id = ? and total_score > ?', category_id, 0).
      order('total_score DESC').limit(n)
  }
end
