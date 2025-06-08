
#TODO MAke the validation better since joker is also a permissible value
class Card < ApplicationRecord
  SUITS = %w[spade heart club diamond].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 11 12 13 a].freeze

  RENT_COST = 1 # in cents
  RESTOCK_COST = 50 # in cents

  COMPLETE_DECK_SIZE = 53 # 52 standard cards + 1 joker
  MAX_RENT_TIME = 15.minutes # Maximum time a card can be rented before it is considered overdue

  validates :suit, inclusion: { in: SUITS }, unless: :joker?
  validates :value, inclusion: { in: VALUES }, unless: :joker?

  validates :suit, presence: true, unless: :joker?
  validates :value, presence: true
  validates :status, presence: true 
  validates :rented_at, presence: true, if: :rented? # need to rm all the validations whcich use the rentend_at
  
  enum :status, { available: 0, rented: 1, lost: 2 }

  has_many :transactions, dependent: :destroy

  # Initialize the deck with all cards
  def self.setup_deck
    # Housekeeping to avoid duplicates between sessions:
    # Card.destroy_all ensures that all existing cards are removed from the database,
    # allowing the setup of a new deck without any duplication or leftover data.
    Card.destroy_all

    add_standard_cards
    add_joker
  end

  def self.handout_random_card
    raise 'No available cards' if Card.available.empty?
    
    random_card = Card.available.sample
    random_card.rent!

    random_card
  end

  def rent!
    raise 'The card trying to be rentend is not available' unless available?

    update!(status: 'rented', rented_at: Time.current)
  end

  def lost!
    return if lost?
    # ban the user from renting this card again
    update!(status: 'lost')

    Transaction.charge_replacement_fees!(self, RESTOCK_COST)
  end

  def lost_or_overdue?
    lost? || overdue?
  end

  def joker?
    value == 'joker'
  end

  def self.complete_deck?
    count == COMPLETE_DECK_SIZE
  end

  def self.restock_cards
    return unless lost.present?

    lost.each do |lost_card|
      lost_card.make_it_available!
      Transaction.charge_replacement_fees!(lost_card, RESTOCK_COST)
    end
  end

  def lost_or_overdue?
    lost? || overdue?
  end
  
  def overdue?
    rented? && ((Time.current - rented_at) > 15.minutes)
  end

  def total_rent_cost
    (elapsed_time / 1.minute).ceil * RENT_COST
  end

  def elapsed_time
    return 0 unless rented?

    [Time.current, rented_at + MAX_RENT_TIME].min - rented_at
  end

  def overdue?
    rented? && ((Time.current - rented_at) > 15.minutes)
  end
end