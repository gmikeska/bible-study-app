# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_13_133754) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "content"
    t.boolean "show_in_feed", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bibles", force: :cascade do |t|
    t.string "bible_id"
    t.string "dblId"
    t.string "name"
    t.string "language"
    t.string "language_id"
    t.string "nameLocal"
    t.string "abbreviation"
    t.string "abbreviationLocal"
    t.string "description"
    t.string "descriptionLocal"
    t.string "books"
    t.string "copyright"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.string "visibility"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "summary"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
  end

  create_table "courses_pets", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "pet_id", null: false
    t.index ["course_id"], name: "index_courses_pets_on_course_id"
    t.index ["pet_id"], name: "index_courses_pets_on_pet_id"
  end

  create_table "donations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "amount_in_btc_cents", default: 0, null: false
    t.string "amount_in_btc_currency", default: "USD", null: false
    t.string "payment_method"
    t.string "category"
    t.string "payment_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "name"
    t.text "subject"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "recipients"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "course_id"
    t.integer "current_chapter_id"
    t.string "quiz_responses"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "invoice_id"
    t.integer "user_id"
    t.index ["invoice_id"], name: "index_enrollments_on_invoice_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "instructions", force: :cascade do |t|
    t.datetime "occurred"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "attending"
    t.string "messages"
    t.string "status"
  end

  create_table "interactions", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.string "visibility"
    t.string "interaction_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "user_id"
    t.string "payments"
    t.string "number"
    t.boolean "refunded"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.string "visibility"
    t.text "content"
    t.integer "course_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "chapter_id"
    t.text "slides"
    t.string "messages"
  end

  create_table "pages", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "visibility"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "components"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "questions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lesson_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "user_type"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
    t.boolean "online"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verses", force: :cascade do |t|
    t.integer "bible_id"
    t.string "verse_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reading_id"
    t.index ["bible_id"], name: "index_verses_on_bible_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
