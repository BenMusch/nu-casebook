class CreateBowlers < ActiveRecord::Migration
  def change
    create_table :bowlers do |t|
      t.string :name
      t.float :avg_score
      t.integer :num_rounds

      t.timestamps null: false
    end
  end
end
