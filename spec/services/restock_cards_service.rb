require 'rails_helper'

RSpec.describe RestockCardsService do
  describe '#call' do
    subject { described_class.new }

    let!(:client) { Client.create!(ip_address: "Test IP", status: :active) }
    let!(:card) { Card.create!(suit: "heart", value: "8", status: status, client: client) }

    context 'when card is lost' do
      let(:status) { :lost }

      it 'makes the lost card available' do
        expect {
          subject.call
          card.reload
        }.to change(card, :lost?).from(true).to(false)
         .and change(card, :available?).from(false).to(true)
      end

      it 'charges a replacement fee' do
        expect(Transaction).to receive(:charge_replacement_fees!).with(card, Card::RESTOCK_COST)
        subject.call
      end
    end

    context 'when card is already available' do
      let(:status) { :available }

      it 'does not change the status of the card' do
        expect {
          subject.call
          card.reload
        }.not_to change(card, :status)
      end

      it 'does not charge a replacement fee' do
        expect(Transaction).not_to receive(:charge_replacement_fees!)
        subject.call
      end
    end
  end
end
