module Api
  class CardsController < ::ApplicationController
    BLOCKED_IPS = []

    before_action :initialize_deck, only: [:show]
    before_action :block_request, if: :unsafe_ip_address? # Move this to ApplicationController or a concern if needed

    protect_from_forgery with: :null_session # Move this to ApplicationController 


    def show
      card = Card.handout_random_card

      render json: card, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
      card = Card.find_by(suit: params[:suit], value: params[:value])
      return render json: { error: 'invalid card' }, status: :not_found unless card.present? # Could also be a bad request error?
  
      card.return!
      render json: card, status: :ok
    end

    private

    def initialize_deck
      Card.setup_deck unless Card.complete_deck?
    end

    def card_params
      params.expect(card: [:suit, :value])
    end

    def block_request
      render json: { error: 'Access denied' }, status: :forbidden
    end

    def unsafe_ip_address?
      BLOCKED_IPS.include?(request.remote_ip)
    end
  end
end