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

ActiveRecord::Schema.define(version: 20151202225111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "associations", force: :cascade do |t|
    t.integer "question_id"
    t.string  "left_text"
    t.string  "right_text"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string "name"
  end

  create_table "groups_toasts", force: :cascade do |t|
    t.integer "group_id"
    t.integer "toast_id"
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "mark_systems", force: :cascade do |t|
    t.string "name"
  end

  create_table "marks", force: :cascade do |t|
    t.string  "presentation"
    t.integer "percent"
    t.integer "mark_system_id"
  end

  create_table "plurals", force: :cascade do |t|
    t.integer "question_id"
    t.string  "text"
    t.boolean "is_right"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "toast_id"
    t.text    "text"
    t.string  "question_type"
    t.boolean "is_right"
  end

  create_table "questions_toasts", id: false, force: :cascade do |t|
    t.integer "toast_id",    null: false
    t.integer "question_id", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer  "toast_id"
    t.integer  "user_id"
    t.decimal  "hit",        precision: 3, scale: 2
    t.datetime "created_at"
    t.jsonb    "answers"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
  end

  create_table "subjects_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "subject_id"
  end

  create_table "toasts", force: :cascade do |t|
    t.integer "subject_id"
    t.string  "name"
    t.integer "mark_system_id"
    t.jsonb   "options",        default: {"weights"=>{"plural"=>1, "logical"=>1, "association"=>1}}
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                            default: "",        null: false
    t.string   "encrypted_password",               default: "",        null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "father_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "config"
    t.string   "role",                   limit: 7, default: "student"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role"], name: "index_users_on_role", using: :btree

end
