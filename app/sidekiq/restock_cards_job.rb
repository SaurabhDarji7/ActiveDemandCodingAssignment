require 'sidekiq-scheduler'

class RestockCardsJob
  include Sidekiq::Job

  def perform(*args)
    Rails.logger.info "[RestockCardsJob]----------------------- Starting the Restocking of Cards -----------------------"
    RestockCardsService.new.call
    Rails.logger.info "[RestockCardsJob]----------------------- Restocking Completed-----------------------"
  end
end
