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

ActiveRecord::Schema.define(version: 20151109161104) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.text     "auth_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "rank"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_sets", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "level_id"
    t.integer  "user_id"
    t.integer  "questions_count"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_sets", ["category_id", "level_id", "user_id"], name: "index_question_sets", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "question_set_id"
    t.text     "question"
    t.string   "answer"
    t.text     "choices"
    t.integer  "right_answer_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["question_set_id"], name: "index_questions_on_question_set_id", using: :btree

  create_table "user_question_ratings", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "rating"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_question_ratings", ["user_id", "question_id", "rating"], name: "index_user_question_ratings", using: :btree
  
  create_table "user_question_sets", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_set_id"
    t.integer  "score"
    t.integer  "status"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "answers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_question_sets", ["user_id", "question_set_id"], name: "index_user_question_sets", using: :btree

  create_table "user_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "total_score"
    t.integer  "question_sets_count"
    t.integer  "category_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_scores", ["user_id", "category_id"], name: "index_user_scores_on_user_and_categories", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
