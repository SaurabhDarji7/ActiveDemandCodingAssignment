
#TODO MAke the validation better since joker is also a permissible value
class Card < ApplicationRecord
  SUITS = %w[spade heart club diamond].freeze
  VALUES = %w[2 3 4 5 6 7 8 9 10 11 12 13 a].freeze

  RENT_COST = 0.01 # in cents
  RESTOCK_COST = 0.5 # in cents

  COMPLETE_DECK_SIZE = 53 # 52 standard cards + 1 joker
  MAX_RENT_TIME = 15.minutes # Maximum time a card can be rented before it is considered overdue

  validates :suit, inclusion: { in: SUITS }, unless: :joker?
  validates :value, inclusion: { in: VALUES + ['joker']}

  validates :suit, presence: true, unless: :joker?
  validates :value, presence: true
  validates :status, presence: true 
  validates :rented_at, presence: true, if: :rented? # need to rm all the validations whcich use the rentend_at
  
  enum :status, { available: 0, rented: 1, lost: 2 }

  scope :overdue, -> { where(status: :rented).where("rented_at < ?", MAX_RENT_TIME.ago) }

  has_many :transactions, dependent: :destroy
  belongs_to :client, optional: true

  def self.handout_random_card_to(current_client)
    raise 'No available cards' if Card.available.empty?
    
    random_card = Card.available.sample
    random_card.rent_to!(current_client)
    random_card
  end

  def rent_to!(current_client)
    raise 'The card trying to be rentend is not available' unless available?

    update!(status: 'rented', rented_at: Time.current, client_id: current_client.id)
  end

  def lost!
    raise 'The card trying to return is already marked lost' if lost?

    update!(status: 'lost')
  end

  def make_it_available!
    raise 'The card trying to be made available is already available!.' if available?

    update!(status: 'available', rented_at: nil, client_id: nil)
  end

  def self.complete_deck?
    count == COMPLETE_DECK_SIZE
  end

  def joker?
    value == 'joker'
  end

  def lost_or_overdue?
    lost? || overdue?
  end
  
  def overdue?
    rented? && (elapsed_time > MAX_RENT_TIME)
  end

  def total_rent_cost
    ([elapsed_time, MAX_RENT_TIME].min / 1.minute).ceil * RENT_COST
  end

  private

  def elapsed_time
    raise 'Card not rented, for it to have an elapsed time' unless rented?

    Time.current - rented_at
  end
end
