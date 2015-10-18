class CreateQuestionSets < ActiveRecord::Migration
  def change
    create_table :question_sets do |t|
      t.string :name
      t.integer :category_id
      t.integer :level_id
      t.integer :user_id
      t.integer :questions_count
      t.boolean :approved

      t.timestamps
    end

    add_index :question_sets, [:category_id, :level_id, :user_id], name: 'index_question_sets'
  end
end
