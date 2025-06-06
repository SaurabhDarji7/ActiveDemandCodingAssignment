
#TODO MAke the validation better since joker is also a permissible value
class Card < ApplicationRecord
  SUITS = %w[spade heart club diamond].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 11 12 13 a].freeze
  
  validates :suit, inclusion: { in: SUITS }, unless: :joker?
  validates :value, inclusion: { in: VALUES }, unless: :joker?

  validates :suit, presence: true, unless: :joker?
  validates :value, presence: true
  validates :status, presence: true 
  
  enum :status, { available: 0, rented: 1, lost: 2, damaged: 3 }

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
    raise 'The card trying to be returned is not rented' unless rented?

    update!(status: 'available')
  end

  def joker?
    value == 'joker'
  end

  def self.complete_deck?
    count == 53
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
end