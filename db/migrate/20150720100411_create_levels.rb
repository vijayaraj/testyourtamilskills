class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name
      t.text :description 
      t.integer :rank
      t.integer :category_id

      t.timestamps
    end
  end
end
