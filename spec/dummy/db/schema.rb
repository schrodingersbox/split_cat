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

ActiveRecord::Schema.define(version: 20130909061041) do

  create_table "split_cat_experiments", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.integer  "winner_id"
    t.datetime "created_at"
  end

  add_index "split_cat_experiments", ["name"], name: "index_split_cat_experiments_on_name", unique: true

  create_table "split_cat_goal_subjects", force: true do |t|
    t.integer  "goal_id"
    t.integer  "subject_id"
    t.integer  "experiment_id"
    t.integer  "hypothesis_id"
    t.datetime "created_at"
  end

  add_index "split_cat_goal_subjects", ["goal_id", "subject_id"], name: "index_split_cat_gs_on_goal_id_and_subject_id", unique: true

  create_table "split_cat_goals", force: true do |t|
    t.integer  "experiment_id"
    t.string   "name",          null: false
    t.string   "description"
    t.datetime "created_at"
  end

  add_index "split_cat_goals", ["experiment_id", "name"], name: "index_split_cat_goals_on_experiment_id_and_name", unique: true

  create_table "split_cat_hypotheses", force: true do |t|
    t.integer  "experiment_id"
    t.string   "name",          null: false
    t.string   "description"
    t.integer  "weight"
    t.datetime "created_at"
  end

  add_index "split_cat_hypotheses", ["experiment_id", "name"], name: "index_split_cat_hypotheses_on_experiment_id_and_name", unique: true

  create_table "split_cat_hypothesis_subjects", force: true do |t|
    t.integer  "hypothesis_id"
    t.integer  "subject_id"
    t.integer  "experiment_id"
    t.datetime "created_at"
  end

  add_index "split_cat_hypothesis_subjects", ["experiment_id", "subject_id"], name: "index_split_cat_hs_on_experiment_id_and_subject_id", unique: true

  create_table "split_cat_subjects", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
  end

  add_index "split_cat_subjects", ["token"], name: "index_split_cat_subjects_on_token", unique: true

end
