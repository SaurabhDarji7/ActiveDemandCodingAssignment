class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :check_for_lost_cards

  private

  def check_for_lost_cards
    Card.find_and_mark_lost_cards
  end
end
