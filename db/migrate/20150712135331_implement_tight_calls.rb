class ImplementTightCalls < ActiveRecord::Migration
  def change
    create_table "rounds", force: :cascade do |t|
      t.integer  "case_id"
      t.text     "rfd"
      t.boolean  "win"
      t.float    "speaks"
      t.datetime "created_at",                 null: false
      t.datetime "updated_at",                 null: false
      t.boolean  "tight_call", default: false
      t.integer  "side_id"
    end
    add_column :cases, :tight_call_losses, :integer, default: 0
    add_column :cases, :tight_call_wins, :integer, default: 0
  end
end
