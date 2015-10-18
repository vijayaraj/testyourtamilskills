class CreateUserQuestionSets < ActiveRecord::Migration
  def change
    create_table :user_question_sets do |t|
      t.integer :user_id
      t.integer :question_set_id
      t.integer :score
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time
      t.text :answers

      t.timestamps
    end

    add_index :user_question_sets, [:user_id, :question_set_id], name: 'index_user_question_sets'
  end
end
