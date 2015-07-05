class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :case, index: true, foreign_key: true
      t.text :rfd
      t.boolean :win
      t.float :speaks

      t.timestamps null: false
    end
  end
end
