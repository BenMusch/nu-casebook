class CreateExcludingViewers < ActiveRecord::Migration
  def change
    create_table :excluding_viewers do |t|
      t.belongs_to :viewer, index: true, foreign_key: true
      t.belongs_to :search, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
