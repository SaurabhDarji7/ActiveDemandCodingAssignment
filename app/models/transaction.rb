class Transaction < ApplicationRecord
  enum :transaction_type, { initial_balance: 0, rent: 1, card_replacement: 2 }

  validates :transaction_type, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  after_create :exit_application, unless: -> { self.class.total_balance > 0 }

  belongs_to :card

  INITIAL_BALANCE = 5 # in dollars

  def self.total_balance
    INITIAL_BALANCE - pending_rent - pending_replacement
  end

  def self.pending_rent
    Transaction.rent.sum(:amount)
  end

  def self.pending_replacement
    Transaction.card_replacement.sum(:amount)
  end

  def self.recent_transactions(time_frame_hrs: 3)
    Transaction.where('created_at >= ?', Time.current - time_frame_hrs.hours)
  end

  def self.collect_rent!(card, amount)
    transaction = Transaction.new(transaction_type: :rent, amount: amount, card: card)
    transaction.save!
    transaction
  end

  def self.charge_replacement_fees!(card, amount)
    transaction = Transaction.new(transaction_type: :card_replacement, amount: amount, card: card)
    transaction.save!
    transaction
  end

  private

  def exit_application
    Rails.logger.info "Exiting application due to insufficient balance."
    exit(0)
  end
end
