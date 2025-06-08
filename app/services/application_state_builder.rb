class ApplicationStateBuilder
  def initialize
  end

  def call
    cleanup_data
    BuildDeckService.new.call
  end

  private

  def cleanup_data
    Card.destroy_all
    Transaction.destroy_all
  end
end