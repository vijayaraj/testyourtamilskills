module CategoriesHelper
  
  def answered_question_sets_count(category, level)
    return 0 unless current_user
    current_user.filter_answered_question_sets(category.id, level.id).count
  end

  def score(category, level)
    return 0 unless current_user
    current_user.score(category, level) || 0
  end

  def can_play?(level)
    level.previous_level_completed?
  end
end
