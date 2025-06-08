class ReturnCardService
  def initialize(card)
    @card = card
  end

  def call
    ActiveRecord::Base.transaction do
      @card.make_it_available!
      Transaction.collect_rent!(@card, @card.total_rent_cost)
    end
  rescue => e
    Rails.logger.error("Failed to return card: #{e.message}")
    raise
  end
end
