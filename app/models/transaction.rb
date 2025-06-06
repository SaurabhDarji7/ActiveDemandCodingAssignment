class Transaction < ApplicationRecord
  enum transaction_type: { initial_balance: 0, rent: 1, card_replacement: 2 }

  validates :transaction_type, presence: true
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :card

  def amount_in_dollars
    amount_cents / 100.0
  end

  def initialize(attributes = {})
    super
    load_initial_balance if Transaction.count.zero?
  end

  private

  def self.load_initial_balance
    create!(transaction_type: :initial_balance, amount_cents: 500)
  end
end
