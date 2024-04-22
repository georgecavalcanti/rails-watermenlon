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

ActiveRecord::Schema[7.1].define(version: 2024_04_22_121442) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "name"
    t.bigint "external_created_at"
    t.bigint "external_update_at"
    t.bigint "last_modified_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "schedule_id"
    t.bigint "person_id"
    t.string "name"
    t.text "content"
    t.bigint "external_created_at"
    t.bigint "external_update_at"
    t.bigint "last_modified_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_notes_on_person_id"
    t.index ["schedule_id"], name: "index_notes_on_schedule_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.bigint "external_created_at"
    t.bigint "external_update_at"
    t.bigint "last_modified_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "person_id"
    t.string "execution_date"
    t.string "name"
    t.bigint "external_created_at"
    t.bigint "external_update_at"
    t.bigint "last_modified_at"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_schedules_on_person_id"
  end

  create_table "sync_jsons", force: :cascade do |t|
    t.bigint "last_pulled_at"
    t.json "changes", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "people"
  add_foreign_key "notes", "schedules"
  add_foreign_key "schedules", "people"
end