class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :total_score
      t.integer :question_sets_count
      t.integer :category_score

      t.timestamps
    end
    add_index :user_scores, [:user_id, :category_id], name: 'index_user_scores_on_user_and_categories'
  end
end
