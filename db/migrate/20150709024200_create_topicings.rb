class CreateTopicings < ActiveRecord::Migration
  def change
    create_table :topicings do |t|
      t.belongs_to :case, index: true, foreign_key: true
      t.belongs_to :topic, index: true, foreign_key: true
    end
  end
end
