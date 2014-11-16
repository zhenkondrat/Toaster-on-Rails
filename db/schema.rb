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

ActiveRecord::Schema.define(version: 20141116172606) do

  create_table "answer1s", force: true do |t|
    t.integer "question_id"
    t.boolean "is_right"
  end

  create_table "answer2s", force: true do |t|
    t.integer "question_id"
    t.string  "answer"
    t.boolean "is_right"
  end

  create_table "answer3s", force: true do |t|
    t.integer "question_id"
    t.text    "field"
    t.boolean "side"
    t.integer "compare"
  end

  create_table "groups", force: true do |t|
    t.string "name"
  end

  create_table "invite_codes", force: true do |t|
    t.string  "token"
    t.date    "date"
    t.boolean "admin"
  end

  create_table "mark_systems", force: true do |t|
    t.string "name"
  end

  create_table "marks", force: true do |t|
    t.integer "mark_system_id"
    t.string  "presentation"
    t.integer "percent"
  end

  create_table "questions", force: true do |t|
    t.integer "test_id"
    t.text    "condition"
    t.integer "question_type"
  end

  create_table "results", force: true do |t|
    t.integer  "test_id"
    t.integer  "user_id"
    t.decimal  "mark",       precision: 3, scale: 2
    t.datetime "created_at"
  end

  create_table "subjects", force: true do |t|
    t.string "subject_name"
  end

  create_table "test_groups", force: true do |t|
    t.integer "group_id"
    t.integer "test_id"
  end

  create_table "tests", force: true do |t|
    t.integer "subject_id"
    t.string  "name"
    t.integer "weight1"
    t.integer "weight2"
    t.integer "weight3"
    t.integer "questions_count"
    t.integer "question_time"
    t.integer "mark_system"
  end

  create_table "user_groups", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "users", force: true do |t|
    t.string   "login",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "father_name"
    t.boolean  "admin"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
