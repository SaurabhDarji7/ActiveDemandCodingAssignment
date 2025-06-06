
#TODO MAke the validation better since joker is also a permissible value
class Card < ApplicationRecord
  SUITS = %w[spade heart club diamond].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 11 12 13 a].freeze

  RENT_COST = 1.freeze # in cents
  RESTOCK_COST = 50.freeze # in cents

  COMPLETE_DECK_SIZE = 53.freeze # 52 standard cards + 1 joker

  validates :suit, inclusion: { in: SUITS }, unless: :joker?
  validates :value, inclusion: { in: VALUES }, unless: :joker?

  validates :suit, presence: true, unless: :joker?
  validates :value, presence: true
  validates :status, presence: true 
  
  enum :status, { available: 0, rented: 1, lost: 2 }

  has_many :transactions, dependent: :destroy

  # Initialize the deck with all cards
  def self.setup_deck
    # Housekeeping to avoid duplicates betweeen the sessions
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

  def return!
    raise 'The card trying to be returned is not rented (violating the uniqueness constraint on a standard deck of cards).' unless rented?
    if lost?
      lost!
      raise 'The card trying to be returned has already been declared as \'lost\'.' 
    end

    update!(status: 'available')
    Transaction.create_rent_transaction(self, total_rent_cost)
  end

  # Overriding the lost? method of the enum to include the overdue condition
  def lost?
    super || (rented? && rented_at.present? && ((Time.current - rented_at) > 15.minutes))
  end

  def lost!
    return if lost?
    # ban the user from renting this card again
    update!(status: 'lost')

    Transaction.create_replacement_transaction(self, RESTOCK_COST)
  end

  def joker?
    value == 'joker'
  end

  def self.complete_deck?
    count == COMPLETE_DECK_SIZE
  end

  def restock_cards
    return unless lost.present?

    update!(status: 'available', rented_at: nil)
    Transaction.create_replacement_transaction(self, RESTOCK_COST)
  end

  private

  def self.add_standard_cards
    SUITS.each do |suit|
      VALUES.each do |value|
        create(suit: suit, value: value, status: 'available')
      end
    end
  end

  def self.add_joker
    create(suit: nil, value: 'joker', status: 'available')
  end

  def total_rent_cost
    return 0 unless rented_at

    #TODO: Check how to use this min function
    elapsed_time = min(Time.current, rented_at + 15.mins) - rented_at
    (elapsed_time / 1.minute).ceil * RENT_COST
  end
end