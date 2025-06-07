class ReturnCardService
  def initialize(card, ip_address)
    @card ||= card
    @ip_address ||= ip_address
  end

  def call
    validate_card!

    return handle_overdue_card if @card.overdue?

    @card.make_it_available!
    Transaction.collect_rent!(@card, @card.total_rent_cost)
  end

  private

  def validate_card!
    raise 'The card trying to be returned is not rented (violating the uniqueness constraint on a standard deck of cards).' unless @card.rented?
    raise 'The card trying to be returned has already been declared as \'lost\'.' if @card.lost?
  end

  def ban_client!
    BlacklistedClient.create!(ip_address: @ip_address)
  end

  def handle_overdue_card
    ban_client!
    @card.lost!
  end
end
