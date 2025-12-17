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

ActiveRecord::Schema[7.2].define(version: 2025_12_17_065518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buyers", force: :cascade do |t|
    t.string "userable_type"
    t.bigint "userable_id"
    t.integer "purchase_count", default: 0
    t.integer "total_spent", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["userable_type", "userable_id"], name: "index_buyers_on_userable"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "type"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_items", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "item_id", null: false
    t.index ["category_id", "item_id"], name: "index_categories_items_on_category_id_and_item_id"
    t.index ["item_id", "category_id"], name: "index_categories_items_on_item_id_and_category_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "item_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "seller_id", null: false
    t.index ["buyer_id"], name: "index_conversations_on_buyer_id"
    t.index ["item_id"], name: "index_conversations_on_item_id"
    t.index ["seller_id"], name: "index_conversations_on_seller_id"
  end

  create_table "deals", force: :cascade do |t|
    t.decimal "agreed_price"
    t.integer "status"
    t.boolean "seller_marked_done"
    t.boolean "buyer_marked_done"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "conversation_id", null: false
    t.bigint "proposer_id", null: false
    t.bigint "item_id", null: false
    t.index ["conversation_id"], name: "index_deals_on_conversation_id"
    t.index ["item_id"], name: "index_deals_on_item_id"
    t.index ["proposer_id"], name: "index_deals_on_proposer_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "title"
    t.text "desc"
    t.integer "status"
    t.text "warranty"
    t.string "color"
    t.decimal "price"
    t.integer "condition"
    t.boolean "is_negotiable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seller_id", null: false
    t.index ["seller_id"], name: "index_items_on_seller_id"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "buyer_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.index ["buyer_id"], name: "index_likes_on_buyer_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "conversation_id", null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.decimal "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reviewer_id", null: false
    t.bigint "seller_id", null: false
    t.bigint "deal_id", null: false
    t.index ["deal_id"], name: "index_reviews_on_deal_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["seller_id"], name: "index_reviews_on_seller_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "userable_type"
    t.bigint "userable_id"
    t.string "avg_rating"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["userable_type", "userable_id"], name: "index_sellers_on_userable"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conversations", "buyers"
  add_foreign_key "conversations", "items"
  add_foreign_key "conversations", "sellers"
  add_foreign_key "deals", "conversations"
  add_foreign_key "deals", "items"
  add_foreign_key "deals", "users", column: "proposer_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "reviews", "buyers", column: "reviewer_id"
end
