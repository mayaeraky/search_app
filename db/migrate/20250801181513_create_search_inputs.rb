class CreateSearchInputs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_inputs do |t|
      t.text :keyword, null: false
      t.integer :occurrences, default: 1
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
