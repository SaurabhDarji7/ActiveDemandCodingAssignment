class RestockCardsJob
  include Sidekiq::Job

  def perform(*args)
    Rails.logger.info "[RestockCardsJob]----------------------- Starting the Restocking of Cards -----------------------"
    Card.restock_cards
    Rails.logger.info "[RestockCardsJob]----------------------- Restocking Completed-----------------------"
  end
end
