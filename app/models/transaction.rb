class Transaction < ApplicationRecord
  enum :transaction_type, { initial_balance: 0, rent: 1, card_replacement: 2 }

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

  def self.total_balance
    Transaction.sum(:amount_cents) / 100.0
  end

  def self.pending_rent
    Transaction.rent.sum(:amount_cents) / 100.0
  end

  def self.pending_replacement
    Transaction.card_replacement.sum(:amount_cents) / 100.0
  end

  def self.recent_transactions(time_frame_hrs: 3)
    Transaction.where('created_at >= ?', Time.current - time_frame_hrs.hours)
  end
  private

  def load_initial_balance
    self.transaction_type = :initial_balance
    self.amount_cents = 500
  end
end
