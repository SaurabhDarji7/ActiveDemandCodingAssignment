require 'rails_helper'

RSpec.describe ReturnCardService do
  describe '#call' do
    subject(:service_call) { described_class.new(card).call }

    let!(:client) { Client.create!(ip_address: "Test IP", status: :active) }
    let!(:card) do
      Card.create!(suit: "heart", value: "8", status: status, rented_at: rented_at, client: client)
    end

    context 'when the card is rented' do
      let(:status) { :rented }
      let(:rented_at) { 5.seconds.ago }

      it 'collects rent' do
        expect(Transaction).to receive(:collect_rent!).with(card, card.total_rent_cost)
        service_call
      end

      it 'marks the card as available' do
        allow(Transaction).to receive(:collect_rent!) # prevent actual call
        expect {
          service_call
          card.reload
        }.to change(card, :available?).from(false).to(true)
      end

      it 'removes the rented status' do
        allow(Transaction).to receive(:collect_rent!)
        service_call
        expect(card.reload).not_to be_rented
      end
    end

    context 'when the card is lost' do
      let(:status) { :lost }
      let(:rented_at) { nil }

      it 'raises a lost card error' do
        expect { service_call }.to raise_error('A lost card cannot be returned!')
      end

      it 'does not change the card status' do
        expect { service_call rescue nil }.not_to change { card.reload.status }
      end
    end

    context 'when the card is available (not rented)' do
      let(:status) { :available }
      let(:rented_at) { nil }

      it 'raises a not-rented error' do
        expect { service_call }.to raise_error('A card that is not currently rented cannot be returned!')
      end

      it 'does not change the card status' do
        expect { service_call rescue nil }.not_to change { card.reload.status }
      end
    end
  end
end
