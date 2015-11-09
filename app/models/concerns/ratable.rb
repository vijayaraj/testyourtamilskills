module Ratable
  extend ActiveSupport::Concern

  def rating_score(user)
    user_rating = rating(user)
    user_rating.rating if user_rating
  end

  def feedback(user)
    user_rating = rating(user)
    user_rating.feedback if user_rating
  end

  def rating(user)
    ratings.find_by(user_id: user.id)
  end

  def overall_rating
    ratings.average(:rating)
  end
end
