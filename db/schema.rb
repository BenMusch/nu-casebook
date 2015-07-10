# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150710031856) do

  create_table "cases", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "case_statement"
    t.boolean  "opp_choice"
    t.text     "link"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "case_id"
    t.text     "rfd"
    t.boolean  "win"
    t.float    "speaks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rounds", ["case_id"], name: "index_rounds_on_case_id"

  create_table "topicings", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "case_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topicings", ["case_id"], name: "index_topicings_on_case_id"
  add_index "topicings", ["topic_id"], name: "index_topicings_on_topic_id"

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "password_confirmation"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "activated",             default: false
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "viewerings", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "viewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "viewerings", ["round_id"], name: "index_viewerings_on_round_id"
  add_index "viewerings", ["viewer_id"], name: "index_viewerings_on_viewer_id"

  create_table "viewers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
