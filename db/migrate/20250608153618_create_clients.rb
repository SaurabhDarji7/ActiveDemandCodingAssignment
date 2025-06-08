class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :ip_address, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :clients, :ip_address, unique: true
  end
end
