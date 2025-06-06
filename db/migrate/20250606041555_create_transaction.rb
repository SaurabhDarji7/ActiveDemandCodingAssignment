class CreateTransaction < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type, null: false, default: 0
      t.integer :amount_cents, null: false
      t.timestamps

      t.references :card, foreign_key: true, null: false
    end
  end
end
