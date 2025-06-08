class HandleOverdueCardsService
  def initialize
  end

  def call
    return unless Card.overdue.exists?

    Card.overdue.find_each do |card|
      handle_overdue_card(card)
    end
  rescue => e
    Rails.logger.error("Failed to handle overdue card: #{e.message}")
    raise
  end
  
  private

  def handle_overdue_card(card)
    ActiveRecord::Base.transaction do 
      ban_client!
      card.lost!
    end
  end

  def ban_client!(card)
      card.client.ban!
  end
end
