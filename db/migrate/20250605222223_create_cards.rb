class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :suit # can be null for joker
      t.string :value # can be null for joker - can never be empty: 'joker' if it's a joker
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :cards, [:suit, :value], unique: true # Avoid duplicate cards
  end
end
