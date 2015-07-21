class CreateSides < ActiveRecord::Migration
  def change
    create_table :sides do |t|
      t.string :name
      t.integer :wins
      t.integer :losses

      t.timestamps null: false
    end
  end
end
