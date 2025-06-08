class ReturnCardService
  def initialize(card)
    @card = card
  end

  def call
    raise 'A lost card cannot be returned!' if @card.lost?
    raise 'A card that is not currently rented cannot be returned!' unless @card.rented?

    ActiveRecord::Base.transaction do
      Transaction.collect_rent!(@card, @card.total_rent_cost)
      @card.make_it_available!
    end
  rescue => e
    Rails.logger.error("Failed to return card: #{e.message}")
    raise
  end
end
