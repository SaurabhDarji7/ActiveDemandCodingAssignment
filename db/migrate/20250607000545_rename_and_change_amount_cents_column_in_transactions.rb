class RenameAndChangeAmountCentsColumnInTransactions < ActiveRecord::Migration[8.0]
  def change
    rename_column :transactions, :amount_cents, :amount
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2
  end
end
