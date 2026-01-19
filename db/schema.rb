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

ActiveRecord::Schema[8.0].define(version: 2025_08_29_192451) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cli_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cli_items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "examine_text"
    t.bigint "room_id", null: false
    t.boolean "is_pickable", default: true
    t.boolean "picked_up", default: false
    t.string "state", default: "inactive", null: false
    t.json "properties", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cli_items_on_name"
    t.index ["room_id"], name: "index_cli_items_on_room_id"
    t.index ["state"], name: "index_cli_items_on_state"
  end

  create_table "cli_player_items", force: :cascade do |t|
    t.bigint "cli_soork_player_id", null: false
    t.bigint "cli_item_id", null: false
    t.integer "uses_remaining"
    t.integer "current_durability"
    t.boolean "equipped"
    t.datetime "acquired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cli_item_id"], name: "index_cli_player_items_on_cli_item_id"
    t.index ["cli_soork_player_id"], name: "index_cli_player_items_on_cli_soork_player_id"
  end

  create_table "cli_room_connections", force: :cascade do |t|
    t.bigint "source_room_id", null: false
    t.bigint "target_room_id", null: false
    t.string "direction", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_room_id", "direction"], name: "index_cli_room_connections_on_source_room_id_and_direction", unique: true
    t.index ["source_room_id"], name: "index_cli_room_connections_on_source_room_id"
    t.index ["target_room_id"], name: "index_cli_room_connections_on_target_room_id"
  end

  create_table "cli_room_visits", force: :cascade do |t|
    t.bigint "cli_soork_player_id", null: false
    t.bigint "cli_room_id", null: false
    t.integer "visit_count"
    t.datetime "last_visited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cli_room_id"], name: "index_cli_room_visits_on_cli_room_id"
    t.index ["cli_soork_player_id"], name: "index_cli_room_visits_on_cli_soork_player_id"
  end

  create_table "cli_rooms", force: :cascade do |t|
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
    t.index ["soork_id", "start_room"], name: "index_cli_rooms_on_soork_id_and_start_room", unique: true, where: "(start_room = true)"
    t.index ["soork_id"], name: "index_cli_rooms_on_soork_id"
    t.index ["state"], name: "index_cli_rooms_on_state"
  end

  create_table "cli_soork_players", force: :cascade do |t|
    t.bigint "cli_soork_id", null: false
    t.bigint "user_id"
    t.bigint "current_room_id", null: false
    t.jsonb "game_state_flags", default: {}, null: false
    t.string "state", default: "active", null: false
    t.boolean "requires_login", default: false
    t.datetime "last_played_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cli_soork_id"], name: "index_cli_soork_players_on_cli_soork_id"
    t.index ["current_room_id"], name: "index_cli_soork_players_on_current_room_id"
    t.index ["game_state_flags"], name: "index_cli_soork_players_on_game_state_flags", using: :gin
    t.index ["state"], name: "index_cli_soork_players_on_state"
    t.index ["user_id"], name: "index_cli_soork_players_on_user_id"
  end

  create_table "cli_soorks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.string "state", default: "draft", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state"], name: "index_cli_soorks_on_state"
    t.index ["user_id"], name: "index_cli_soorks_on_user_id"
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

  create_table "web_area_connections", force: :cascade do |t|
    t.bigint "source_area_id", null: false
    t.bigint "target_area_id", null: false
    t.string "direction", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "required_item_id"
    t.index ["direction"], name: "index_web_area_connections_on_direction"
    t.index ["required_item_id"], name: "index_web_area_connections_on_required_item_id"
    t.index ["source_area_id", "target_area_id"], name: "idx_on_source_area_id_target_area_id_5b5082fe53", unique: true
    t.index ["source_area_id"], name: "index_web_area_connections_on_source_area_id"
    t.index ["target_area_id"], name: "index_web_area_connections_on_target_area_id"
  end

  create_table "web_areas", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "first_visit_text"
    t.bigint "soork_id", null: false
    t.boolean "start_area", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soork_id", "start_area"], name: "index_web_areas_on_soork_id_and_start_area", unique: true, where: "(start_area = true)"
    t.index ["soork_id"], name: "index_web_areas_on_soork_id"
  end

  create_table "web_game_session_items", force: :cascade do |t|
    t.bigint "game_session_id", null: false
    t.bigint "item_id", null: false
    t.integer "uses_remaining"
    t.integer "current_durability"
    t.boolean "equipped"
    t.datetime "acquired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id", "item_id"], name: "index_game_session_items_on_game_session_id_and_item_id", unique: true
    t.index ["game_session_id"], name: "index_web_game_session_items_on_game_session_id"
    t.index ["item_id"], name: "index_web_game_session_items_on_item_id"
  end

  create_table "web_game_sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "soork_id", null: false
    t.bigint "current_area_id", null: false
    t.jsonb "game_state_flags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "player_uuid"
    t.index ["current_area_id"], name: "index_web_game_sessions_on_current_area_id"
    t.index ["player_uuid"], name: "index_web_game_sessions_on_player_uuid"
    t.index ["soork_id"], name: "index_web_game_sessions_on_soork_id"
    t.index ["user_id"], name: "index_web_game_sessions_on_user_id"
  end

  create_table "web_interactions", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.bigint "item_id", null: false
    t.string "target_name"
    t.text "success_message"
    t.json "effects"
    t.boolean "consumes_item", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_web_interactions_on_area_id"
    t.index ["item_id"], name: "index_web_interactions_on_item_id"
  end

  create_table "web_items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.text "examine_text"
    t.bigint "area_id", null: false
    t.bigint "soork_id", null: false
    t.boolean "is_pickable", default: true
    t.integer "default_uses", default: 100
    t.integer "default_durability", default: 100
    t.jsonb "properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_web_items_on_area_id"
    t.index ["is_pickable"], name: "index_web_items_on_is_pickable"
    t.index ["name"], name: "index_web_items_on_name"
    t.index ["soork_id"], name: "index_web_items_on_soork_id"
  end

  create_table "web_soorks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.string "state"
    t.boolean "published"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published"], name: "index_web_soorks_on_published"
    t.index ["state"], name: "index_web_soorks_on_state"
    t.index ["user_id"], name: "index_web_soorks_on_user_id"
  end

  add_foreign_key "cli_items", "cli_rooms", column: "room_id"
  add_foreign_key "cli_player_items", "cli_items"
  add_foreign_key "cli_player_items", "cli_soork_players"
  add_foreign_key "cli_room_connections", "cli_rooms", column: "source_room_id"
  add_foreign_key "cli_room_connections", "cli_rooms", column: "target_room_id"
  add_foreign_key "cli_room_visits", "cli_rooms"
  add_foreign_key "cli_room_visits", "cli_soork_players"
  add_foreign_key "cli_rooms", "cli_soorks", column: "soork_id"
  add_foreign_key "cli_soork_players", "cli_rooms", column: "current_room_id"
  add_foreign_key "cli_soork_players", "cli_soorks"
  add_foreign_key "cli_soork_players", "users"
  add_foreign_key "cli_soorks", "users"
  add_foreign_key "web_area_connections", "web_areas", column: "source_area_id"
  add_foreign_key "web_area_connections", "web_areas", column: "target_area_id"
  add_foreign_key "web_area_connections", "web_items", column: "required_item_id"
  add_foreign_key "web_areas", "web_soorks", column: "soork_id"
  add_foreign_key "web_game_session_items", "web_game_sessions", column: "game_session_id"
  add_foreign_key "web_game_session_items", "web_items", column: "item_id"
  add_foreign_key "web_game_sessions", "users"
  add_foreign_key "web_game_sessions", "web_areas", column: "current_area_id"
  add_foreign_key "web_game_sessions", "web_soorks", column: "soork_id"
  add_foreign_key "web_interactions", "web_areas", column: "area_id"
  add_foreign_key "web_interactions", "web_items", column: "item_id"
  add_foreign_key "web_items", "web_areas", column: "area_id"
  add_foreign_key "web_items", "web_soorks", column: "soork_id"
  add_foreign_key "web_soorks", "users"
end
