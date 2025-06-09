require 'rails_helper'

RSpec.describe HandleOverdueCardsService do
  describe '#call' do
    subject(:service_call) { described_class.new.call }

    let!(:client) { Client.create!(ip_address: "Test IP", status: :active) }
    let!(:overdue_card) { Card.create!(suit: "heart", value: "8", status: :rented, client: client, rented_at: 10.days.ago) }
    
    let(:logger) { double("Logger") }

    before do
      allow(Rails).to receive(:logger).and_return(logger)
      allow(Rails.logger).to receive(:info)
    end

    context 'when there are overdue cards' do
      before do
        allow(Card).to receive(:overdue).and_return(Card.where(id: overdue_card.id))
      end

      it 'bans the client for each overdue card' do
        expect_any_instance_of(Client).to receive(:ban!).once
        service_call
      end

      it 'marks overdue cards as lost' do
        service_call
        expect(overdue_card.reload).to be_lost
      end

      it 'logs info when banning clients' do
        expect(logger).to receive(:info).with(/Banned client #{client.id} for overdue card #{overdue_card.suit} #{overdue_card.value}/)
        allow_any_instance_of(Client).to receive(:ban!)
        service_call
      end
    end

    context 'when there are no overdue cards' do
      before do
        allow(Card).to receive(:overdue).and_return(Card.none)
      end

      it 'returns early without taking any action' do
        expect(logger).not_to receive(:info)
        expect(service_call).to be_nil
      end
    end

    context 'when an error occurs during handling' do
      before do
        allow(Card).to receive(:overdue).and_return(Card.where(id: overdue_card.id))
        allow_any_instance_of(Client).to receive(:ban!).and_raise(StandardError, "something went wrong")
      end

      it 'logs the error and re-raises it' do
        expect(logger).to receive(:error).with(/Failed to handle overdue card: something went wrong/)
        expect { service_call }.to raise_error(StandardError, "something went wrong")
      end
    end
  end
end
