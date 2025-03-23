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

ActiveRecord::Schema[7.2].define(version: 2025_03_23_102130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_carts_on_company_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "carts_products", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", null: false
    t.index ["cart_id"], name: "index_carts_products_on_cart_id"
    t.index ["product_id"], name: "index_carts_products_on_product_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain"], name: "index_companies_on_subdomain", unique: true
  end

  create_table "delivery_informations", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "address"
    t.bigint "order_id", null: false
    t.string "number"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_delivery_informations_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "delivery_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_orders_on_company_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_snapshots", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "name"
    t.decimal "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_product_snapshots_on_order_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "stock"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "user_type", default: "customer", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_name", "first_name"], name: "index_users_on_last_name_and_first_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "carts", "companies"
  add_foreign_key "carts", "users"
  add_foreign_key "carts_products", "carts"
  add_foreign_key "carts_products", "products"
  add_foreign_key "delivery_informations", "orders"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "users"
  add_foreign_key "product_snapshots", "orders"
  add_foreign_key "products", "companies"
  add_foreign_key "users", "companies"
end
