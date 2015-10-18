class PopulateUserScores < ActiveRecord::Migration
  def change
    Category.all.each do |category|
      User.all.each do |user|
        if user.user_question_sets.filter_by_category(category.id).count > 0
          user.update_user_scores(category)
        end
      end
    end
  end
end
