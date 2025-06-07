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

ActiveRecord::Schema[8.0].define(version: 2025_06_07_000545) do
  create_table "cards", force: :cascade do |t|
    t.string "suit"
    t.string "value"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "rented_at"
    t.index ["rented_at"], name: "index_cards_on_rented_at"
    t.index ["suit", "value"], name: "index_cards_on_suit_and_value", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type", default: 0, null: false
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "card_id", null: false
    t.index ["card_id"], name: "index_transactions_on_card_id"
  end

  add_foreign_key "transactions", "cards"
end
