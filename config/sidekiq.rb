# config/sidekiq.yml
:scheduler:
  :schedule:
    restock_cards_job: # runs every hour
      cron: '0 0 * * * *'
      class: RestockCardsJob
      queue: default