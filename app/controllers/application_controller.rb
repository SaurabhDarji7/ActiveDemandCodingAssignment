# Using this as it is lightweight!!!
class ApplicationController < ActionController::API
  before_action :set_current_client
  before_action :block_request, if: :unsafe_client?
  before_action :handle_overdue_cards

  private

  def set_current_client
    @current_client = Client.find_or_create_by!(ip_address: request.remote_ip)
  end

  def handle_overdue_cards
    HandleOverdueCardsService.new.call
  end

  def block_request
    render json: { error: 'Access denied' }, status: :forbidden
  end

  def unsafe_client?
    @current_client.banned?
  end
end
