# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_02_175934) do
  create_table "club_invitations", force: :cascade do |t|
    t.integer "club_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.integer "status", default: 0, null: false
    t.string "invited_by_type", null: false
    t.integer "invited_by_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_club_invitations_on_club_id"
    t.index ["email", "club_id"], name: "index_club_invitations_on_email_and_club_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_club_invitations_on_invited_by"
    t.index ["token"], name: "index_club_invitations_on_token", unique: true
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "city"
    t.string "country"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_clubs_on_slug", unique: true
  end

  create_table "races", force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "gate_counter"
    t.integer "staging_counter"
    t.time "registration_deadline"
    t.time "race_start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_races_on_club_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.integer "role", null: false
    t.integer "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_users_on_club_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "club_invitations", "clubs"
  add_foreign_key "races", "clubs"
  add_foreign_key "users", "clubs"
end
