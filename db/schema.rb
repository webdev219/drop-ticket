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

ActiveRecord::Schema[8.0].define(version: 2025_01_18_101911) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ticket_events", force: :cascade do |t|
    t.string "event_id"
    t.string "event_name"
    t.string "event_notes"
    t.string "event_info"
    t.string "event_status"
    t.datetime "event_start_datetime"
    t.datetime "event_end_datetime"
    t.date "event_start_local_date"
    t.time "event_start_local_time"
    t.datetime "onsale_start_datetime"
    t.datetime "onsale_end_datetime"
    t.string "classification_segment"
    t.string "classification_genre"
    t.string "classification_sub_genre"
    t.string "event_image_url"
    t.float "min_price"
    t.float "max_price"
    t.string "currency"
    t.string "attraction_name"
    t.string "attraction_id"
    t.string "attraction_image_url"
    t.string "venue_name"
    t.string "venue_id"
    t.string "venue_street"
    t.string "venue_city"
    t.string "venue_state_code"
    t.string "venue_country_code"
    t.string "venue_latitude"
    t.string "venue_longitude"
    t.string "venue_zip_code"
    t.string "venue_timezone"
    t.string "attraction_url"
    t.string "venue_url"
    t.string "primary_event_url"
    t.string "resale_event_url"
    t.string "presale_name"
    t.string "presale_datetime_range"
    t.string "legacy_event_id"
    t.string "legacy_venue_id"
    t.string "legacy_attraction_id"
    t.string "presale_description"
    t.datetime "presale_start_datetime"
    t.datetime "presale_end_datetime"
    t.string "source"
    t.string "classification_type"
    t.string "classification_sub_type"
    t.string "promoter_id"
    t.string "promoter_name"
    t.string "classification_segment_id"
    t.string "classification_genre_id"
    t.string "classification_sub_genre_id"
    t.string "classification_type_id"
    t.string "classification_sub_type_id"
    t.string "attraction_classification_segment_id"
    t.string "attraction_classification_segment"
    t.string "attraction_classification_genre_id"
    t.string "attraction_classification_genre"
    t.string "attraction_classification_sub_genre_id"
    t.string "attraction_classification_sub_genre"
    t.string "attraction_classification_type_id"
    t.string "attraction_classification_type"
    t.string "attraction_classification_sub_type_id"
    t.string "attraction_classification_sub_type"
    t.float "min_price_with_fees"
    t.float "max_price_with_fees"
    t.string "transactable"
    t.string "hot_event"
    t.string "accessible_seating_detail"
    t.string "ada_phone"
    t.string "ada_custom_copy"
    t.string "ada_hours"
    t.string "accessibility_info"
    t.datetime "api_onsale_start_datetime"
    t.string "please_note"
    t.string "important_information"
    t.date "event_end_local_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["primary_event_url"], name: "index_ticket_events_on_primary_event_url", unique: true
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
end
