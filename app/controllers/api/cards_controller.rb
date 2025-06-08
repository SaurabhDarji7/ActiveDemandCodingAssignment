module Api
  class CardsController < ::ApplicationController

    def show
      card = Card.handout_random_card_to(@current_client)

      render json: card, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
      card = Card.find_by(suit: params[:suit], value: params[:value])
      return render json: { error: 'invalid card' }, status: :not_found unless card.present? # Could also be a bad request error?
  
      ReturnCardService.new(card).call
      render json: { success: 'Card returned!' }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private


    def card_params
      params.expect(card: [:suit, :value])
    end

  end
end