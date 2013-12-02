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

ActiveRecord::Schema.define(version: 20131130152224) do

  create_table "characters", force: true do |t|
    t.text "name"
    t.text "search_word"
  end

  create_table "image_characters", force: true do |t|
    t.integer  "character_id", null: false
    t.integer  "image_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.integer "character_id"
    t.text    "title"
    t.text    "uri"
    t.binary  "blob",         limit: 10485760
    t.text    "face_data"
    t.integer "width"
    t.integer "height"
  end

end
