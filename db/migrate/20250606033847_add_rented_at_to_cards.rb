class AddRentedAtToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :rented_at, :datetime, null: true

    add_index :cards, :rented_at
  end
end
