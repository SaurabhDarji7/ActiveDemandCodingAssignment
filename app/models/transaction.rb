class Transaction < ApplicationRecord
  enum :transaction_type, { initial_balance: 0, rent: 1, card_replacement: 2 }

  validates :transaction_type, presence: true
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 } #Can be nefative for expenses?

  after_create :exit_application, unless: -> { total_balance > 0 }

  belongs_to :card

  INITIAL_BALANCE = 500.freeze # in cents

  def initialize(attributes = {})
    super
    load_initial_balance if Transaction.count.zero?
  end

  # TODO: Maybe create a function for total amount which would be - rent - replacement costs?


  def amount_in_dollars
    amount_cents / 100.0
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

  # Do we need a bang here?
  def self.collect_rent!(card, amount)
    transaction = Transaction.new(transaction_type: :rent, amount_cents: amount, card: card)
    transaction.save!
    transaction
  end

  def self.charge_replacement_fees!(card, amount)
    transaction = Transaction.new(transaction_type: :card_replacement, amount_cents: amount, card: card) # Assuming a fixed cost for lost card
    transaction.save!
    transaction
  end

  private

  def load_initial_balance
    self.transaction_type = :initial_balance
    self.amount_cents = INITIAL_BALANCE
  end

  def exit_application
    Rails.logger.info "Exiting application due to insufficient balance."
    exit(0)
  end
end
