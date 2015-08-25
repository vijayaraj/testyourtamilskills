class CreateUserQuestionSets < ActiveRecord::Migration
  def change
    create_table :user_question_sets do |t|
      t.integer :user_id 
      t.integer :category_id
      t.integer :level_id
      t.integer :question_set_id
      t.integer :score
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time
      t.text :answers

      t.timestamps
    end
  end
end
