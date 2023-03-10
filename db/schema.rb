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

ActiveRecord::Schema[7.0].define(version: 2022_10_18_153946) do
  create_table "downloads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_downloads_on_item_id"
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "kind"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "isbn"
    t.float "purchase_price"
    t.boolean "is_hot"
    t.integer "width"
    t.integer "height"
    t.string "source"
    t.string "format"
    t.integer "duration"
    t.string "quality"
  end

  create_table "product_invoices", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.string "title"
    t.index ["item_id"], name: "index_product_invoices_on_item_id"
    t.index ["user_id"], name: "index_product_invoices_on_user_id"
  end

  create_table "marketing_ratings", force: :cascade do |t|
    t.integer "rating"
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_ratings_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "downloads", "items"
  add_foreign_key "downloads", "users"
  add_foreign_key "product_invoices", "items"
  add_foreign_key "product_invoices", "users"
  add_foreign_key "marketing_ratings", "items"
end
