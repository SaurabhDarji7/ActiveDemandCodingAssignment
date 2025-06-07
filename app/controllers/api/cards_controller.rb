module Api
  class CardsController < ::ApplicationController
    before_action :initialize_deck, :initialize_balance, only: [:show]

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
  
      ReturnCardService.new(card, request.remote_ip).call
      render json: { success: 'Card returned!' }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def initialize_deck
      Card.setup_deck unless Card.complete_deck?
    end

    def initialize_balance
      Transaction.new if Transaction.count.zero?
    end

    def card_params
      params.expect(card: [:suit, :value])
    end

  end
end