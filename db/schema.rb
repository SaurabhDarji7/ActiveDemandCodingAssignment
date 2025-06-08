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

ActiveRecord::Schema[8.0].define(version: 2025_06_08_153624) do
  create_table "cards", force: :cascade do |t|
    t.string "suit"
    t.string "value"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "rented_at"
    t.integer "client_id"
    t.index ["client_id"], name: "index_cards_on_client_id"
    t.index ["rented_at"], name: "index_cards_on_rented_at"
    t.index ["suit", "value"], name: "index_cards_on_suit_and_value", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "ip_address", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_clients_on_ip_address", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type", default: 0, null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_id", null: false
    t.index ["card_id"], name: "index_transactions_on_card_id"
  end

  add_foreign_key "cards", "clients"
  add_foreign_key "transactions", "cards"
end
