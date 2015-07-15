class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keywords
      t.integer :min_speaks
      t.integer :min_wins

      t.timestamps null: false
    end
  end
end
