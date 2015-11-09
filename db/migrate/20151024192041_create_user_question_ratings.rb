class CreateUserQuestionRatings < ActiveRecord::Migration
  def change
    create_table :user_question_ratings do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :rating
      t.text    :feedback

      t.timestamps
    end
    add_index :user_question_ratings, [:user_id, :question_id, :rating],
      name: "index_user_question_ratings"
  end
end
