class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t|
      t.string :title
      t.string :link
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
