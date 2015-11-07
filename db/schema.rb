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

ActiveRecord::Schema.define(version: 20151022045221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "deck_id"
  end

  add_index "cards", ["deck_id"], name: "index_cards_on_deck_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_cards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "e_factor"
    t.integer  "interval"
    t.date     "due_date"
    t.integer  "repetition"
  end

  add_index "user_cards", ["card_id"], name: "index_user_cards_on_card_id", using: :btree
  add_index "user_cards", ["user_id"], name: "index_user_cards_on_user_id", using: :btree

  create_table "user_decks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_decks", ["deck_id"], name: "index_user_decks_on_deck_id", using: :btree
  add_index "user_decks", ["user_id"], name: "index_user_decks_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "user_cards", "cards"
  add_foreign_key "user_cards", "users"
  add_foreign_key "user_decks", "decks"
  add_foreign_key "user_decks", "users"
end
