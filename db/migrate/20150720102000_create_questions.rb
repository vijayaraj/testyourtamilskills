class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :question_set_id
      t.text :question
      t.string :answer
      t.text :choices
      t.integer :right_answer_count

      t.timestamps
    end

    add_index :questions, :question_set_id, name: 'index_questions_on_question_set_id'
  end
end
