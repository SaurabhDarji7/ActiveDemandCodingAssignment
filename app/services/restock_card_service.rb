class RestockCardsService
  def initialize
  end

  def call
    Card.lost.find_each do |card|
      restock_card(card)
    end
  rescue => e
    Rails.logger.error("Failed to restock card: #{e.message}")
    raise
  end

  private

  def restock_card(card)
    ActiveRecord::Base.transaction do
      card.make_it_available!
      Transaction.charge_replacement_fees!(card, Card::RESTOCK_COST)
    end
  end
end
