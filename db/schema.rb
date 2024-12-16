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

ActiveRecord::Schema[8.0].define(version: 2024_12_15_011802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "examine_text"
    t.bigint "room_id", null: false
    t.boolean "is_pickable", default: true
    t.string "state", default: "inactive", null: false
    t.json "properties", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "picked_up", default: false
    t.index ["name"], name: "index_items_on_name"
    t.index ["room_id"], name: "index_items_on_room_id"
    t.index ["state"], name: "index_items_on_state"
  end

  create_table "player_items", force: :cascade do |t|
    t.bigint "soork_player_id", null: false
    t.bigint "item_id", null: false
    t.integer "uses_remaining"
    t.integer "current_durability"
    t.boolean "equipped"
    t.datetime "acquired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_player_items_on_item_id"
    t.index ["soork_player_id"], name: "index_player_items_on_soork_player_id"
  end

  create_table "room_connections", force: :cascade do |t|
    t.bigint "source_room_id", null: false
    t.bigint "target_room_id", null: false
    t.string "direction", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_room_id", "direction"], name: "index_room_connections_on_source_room_id_and_direction", unique: true
    t.index ["source_room_id"], name: "index_room_connections_on_source_room_id"
    t.index ["target_room_id"], name: "index_room_connections_on_target_room_id"
  end

  create_table "room_visits", force: :cascade do |t|
    t.bigint "soork_player_id", null: false
    t.bigint "room_id", null: false
    t.integer "visit_count"
    t.datetime "last_visited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_visits_on_room_id"
    t.index ["soork_player_id"], name: "index_room_visits_on_soork_player_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "first_visit_text"
    t.bigint "soork_id", null: false
    t.integer "x", default: 0, null: false
    t.integer "y", default: 0, null: false
    t.string "state", default: "locked", null: false
    t.boolean "start_room", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soork_id", "start_room"], name: "index_rooms_on_soork_id_and_start_room", unique: true, where: "(start_room = true)"
    t.index ["soork_id"], name: "index_rooms_on_soork_id"
    t.index ["state"], name: "index_rooms_on_state"
  end

  create_table "soork_players", force: :cascade do |t|
    t.bigint "soork_id", null: false
    t.bigint "user_id"
    t.bigint "current_room_id", null: false
    t.jsonb "game_state_flags", default: {}, null: false
    t.string "state", default: "active", null: false
    t.boolean "requires_login", default: false
    t.datetime "last_played_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_room_id"], name: "index_soork_players_on_current_room_id"
    t.index ["game_state_flags"], name: "index_soork_players_on_game_state_flags", using: :gin
    t.index ["soork_id"], name: "index_soork_players_on_soork_id"
    t.index ["state"], name: "index_soork_players_on_state"
    t.index ["user_id"], name: "index_soork_players_on_user_id"
  end

  create_table "soorks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.string "state", default: "draft", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state"], name: "index_soorks_on_state"
    t.index ["user_id"], name: "index_soorks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "items", "rooms"
  add_foreign_key "player_items", "items"
  add_foreign_key "player_items", "soork_players"
  add_foreign_key "room_connections", "rooms", column: "source_room_id"
  add_foreign_key "room_connections", "rooms", column: "target_room_id"
  add_foreign_key "room_visits", "rooms"
  add_foreign_key "room_visits", "soork_players"
  add_foreign_key "rooms", "soorks"
  add_foreign_key "soork_players", "rooms", column: "current_room_id"
  add_foreign_key "soork_players", "soorks"
  add_foreign_key "soork_players", "users"
  add_foreign_key "soorks", "users"
end
