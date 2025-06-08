class BuildDeckService
  def intitialize
  end

  def call
    build_complete_deck
  rescue => e
    Rails.logger.error("Failed to build the deck: #{e.message}")
    raise
  end

  private

  def build_complete_deck
    add_standard_cards
    add_joker_card
  end
  
  def self.add_standard_cards
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        Card.create!(suit: suit, value: value, status: 'available')
      end
    end
  end

  def self.add_joker_card
    Card.create!(suit: nil, value: 'joker', status: 'available')
  end
end