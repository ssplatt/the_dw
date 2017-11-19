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

ActiveRecord::Schema.define(version: 20171119165923) do

  create_table "divisions", force: :cascade do |t|
    t.text     "name"
    t.integer  "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_divisions_on_league_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.text     "name"
    t.integer  "num_teams",     default: 12
    t.integer  "num_divisions", default: 1
    t.integer  "season",        default: 2017
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "pa_yd",         default: 0.04
    t.integer  "pa_td",         default: 6
    t.integer  "pa_int",        default: -2
    t.float    "ru_yd",         default: 0.1
    t.integer  "ru_td",         default: 6
    t.float    "re_yd",         default: 0.1
    t.float    "rec",           default: 0.5
    t.integer  "re_td",         default: 6
    t.integer  "fum",           default: -1
    t.integer  "fuml",          default: -1
    t.integer  "tpc",           default: 2
    t.index ["name"], name: "index_leagues_on_name"
  end

  create_table "lineups", force: :cascade do |t|
    t.integer  "qb_id"
    t.integer  "rb1_id"
    t.integer  "rb2_id"
    t.integer  "wr1_id"
    t.integer  "wr2_id"
    t.integer  "week"
    t.integer  "team_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.float    "qb_score",    default: 0.0
    t.float    "rb1_score",   default: 0.0
    t.float    "rb2_score",   default: 0.0
    t.float    "wr1_score",   default: 0.0
    t.float    "wr2_score",   default: 0.0
    t.float    "total_score", default: 0.0
    t.integer  "division_id"
    t.index ["division_id"], name: "index_lineups_on_division_id"
    t.index ["team_id"], name: "index_lineups_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.text     "name"
    t.text     "logo"
    t.boolean  "is_commissioner",   default: false
    t.integer  "league_id"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "invite_digest"
    t.boolean  "invite_claimed",    default: false
    t.datetime "invite_claimed_at"
    t.float    "season_total"
    t.float    "s1_total"
    t.float    "s2_total"
    t.float    "s3_total"
    t.float    "s4_total"
    t.float    "s5_total"
    t.float    "playoff_total"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["name"], name: "index_teams_on_name"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
