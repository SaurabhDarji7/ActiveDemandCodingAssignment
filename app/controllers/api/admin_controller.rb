module Api
  class AdminController < ::ApplicationController
    
    protect_from_forgery with: :null_session

    def stock
      Card.all # Assuming you want to return all cards in stock
      
      stock = {
        total: Card.count,
        available: Card.available.count,
        rented: Card.rented.count,
        lost: Card.lost.count,
      }


      render json: stock, status: :ok
    end

    private
  end
end