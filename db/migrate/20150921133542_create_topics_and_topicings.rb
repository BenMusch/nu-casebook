class CreateTopicsAndTopicings < ActiveRecord::Migration
  def change
    create_table "topics", force: :cascade do |t|
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

      create_table "topicings", force: :cascade do |t|
      t.integer  "topic_id"
      t.integer  "case_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "topicings", ["case_id"], name: "index_topicings_on_case_id"
    add_index "topicings", ["topic_id"], name: "index_topicings_on_topic_id"
  end
end
