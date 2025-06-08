class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :handle_overdue_cards
  before_action :block_request, if: :unsafe_ip_address? 

  private

  def handle_overdue_cards
    HandleOverdueCardsService.new.call
  end

  def block_request
    render json: { error: 'Access denied' }, status: :forbidden
  end

  def unsafe_ip_address?
    Client.find_or_create_by(ip_address: request.remote_ip).banned?
  end
end
