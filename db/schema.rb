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

ActiveRecord::Schema.define(version: 20160123172509) do

  create_table "bowlers", force: :cascade do |t|
    t.string   "name"
    t.float    "avg_score"
    t.integer  "num_rounds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cases", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.text     "case_statement"
    t.boolean  "opp_choice"
    t.text     "link"
    t.integer  "wins",                      default: 0
    t.integer  "losses",                    default: 0
    t.float    "speaks",                    default: 0.0
    t.integer  "tight_call_losses",         default: 0
    t.integer  "tight_call_wins",           default: 0
    t.float    "win_percentage",            default: 0.0
    t.float    "tight_call_percentage",     default: 0.0
    t.float    "tight_call_win_percentage", default: 0.0
    t.float    "average_speaks",            default: 0.0
    t.integer  "rounds_with_speaks",        default: 0
  end

  create_table "excluding_topics", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "excluding_topics", ["search_id"], name: "index_excluding_topics_on_search_id"
  add_index "excluding_topics", ["topic_id"], name: "index_excluding_topics_on_topic_id"

  create_table "excluding_viewers", force: :cascade do |t|
    t.integer  "viewer_id"
    t.integer  "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "excluding_viewers", ["search_id"], name: "index_excluding_viewers_on_search_id"
  add_index "excluding_viewers", ["viewer_id"], name: "index_excluding_viewers_on_viewer_id"

  create_table "including_topics", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "search_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "including_topics", ["search_id"], name: "index_including_topics_on_search_id"
  add_index "including_topics", ["topic_id"], name: "index_including_topics_on_topic_id"

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id"
  add_index "memberships", ["round_id"], name: "index_memberships_on_round_id"

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

  add_index "rounds", ["case_id"], name: "index_rounds_on_case_id"
  add_index "rounds", ["side_id"], name: "index_rounds_on_side_id"

  create_table "searches", force: :cascade do |t|
    t.string   "keywords"
    t.integer  "min_speaks"
    t.integer  "min_wins"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "min_tight_call"
    t.integer  "max_tight_call"
  end

  create_table "sides", force: :cascade do |t|
    t.string   "name"
    t.integer  "wins",       default: 0
    t.integer  "losses",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "case_id"
  end

  add_index "sides", ["case_id"], name: "index_sides_on_case_id"

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
