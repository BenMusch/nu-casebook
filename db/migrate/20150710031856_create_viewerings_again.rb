class CreateVieweringsAgain < ActiveRecord::Migration
  def change
    create_table :viewerings do |t|
      t.belongs_to :round, index: true, foreign_key: true
      t.belongs_to :viewer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
