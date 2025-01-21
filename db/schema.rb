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

ActiveRecord::Schema[7.1].define(version: 2025_01_18_120119) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "workout_session_id", null: false
    t.bigint "user_id", null: false
    t.string "status"
    t.datetime "start_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.index ["workout_session_id"], name: "index_bookings_on_workout_session_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "role"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.string "location"
    t.integer "duration"
    t.decimal "price"
    t.text "desc"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
  end

  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "workout_sessions"
  add_foreign_key "workout_sessions", "users"
end
