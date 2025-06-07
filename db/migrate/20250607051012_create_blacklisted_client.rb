class CreateBlacklistedClient < ActiveRecord::Migration[8.0]
  def change
    create_table :blacklisted_clients do |t|
      t.string :ip_address, null: false

      t.timestamps
    end

    add_index :blacklisted_clients, :ip_address, unique: true
  end
end
