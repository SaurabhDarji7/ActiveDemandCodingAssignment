class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_for_lost_cards
  before_action :block_request, if: :unsafe_ip_address? 

  private

  def check_for_lost_cards
    Card.find_and_mark_lost_cards
  end

  def block_request
    render json: { error: 'Access denied' }, status: :forbidden
  end

  def unsafe_ip_address?
    BlacklistedClient.find_by(ip_address: request.remote_ip).present?
  end
end
