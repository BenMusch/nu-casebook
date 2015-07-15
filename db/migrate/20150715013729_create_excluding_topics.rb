class CreateExcludingTopics < ActiveRecord::Migration
  def change
    create_table :excluding_topics do |t|
      t.belongs_to :topic, index: true, foreign_key: true
      t.belongs_to :search, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
