module Api
  class AdminController < ::ApplicationController
    
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

    def finances
      balance = Transaction.total_balance
      pending_rent = Transaction.pending_rent
      pending_replacement = Transaction.pending_replacement

      recent_transactions = Transaction.recent_transactions(time_frame_hrs: 3).map do |transaction|
        {
          type: transaction.transaction_type,
          amount: transaction.amount,
          created_at: transaction.created_at
        }
      end

      render json: {
        balance: balance,
        pending_rent: pending_rent,
        pending_replacement: pending_replacement,
        recent_transactions: recent_transactions
      }, status: :ok
      
    end
  end
end