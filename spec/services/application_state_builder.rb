require 'rails_helper'

RSpec.describe ApplicationStateBuilder do
  describe '#call' do
    let!(:client) { Client.create!(ip_address: "Test Client", status: 0) }
    let!(:card) { Card.create!(suit: "heart", value: "8", client: client) }
    let!(:transaction) { Transaction.collect_rent!(card, 0.5) }
    let(:build_deck_service_instance) { instance_double(BuildDeckService, call: true) }

    subject { described_class.new }

    before do
      allow(BuildDeckService).to receive(:new).and_return(build_deck_service_instance)
    end

    it 'cleans up existing card and transaction data' do
      expect {
        subject.call
      }.to change(Card, :count).from(1).to(0)
       .and change(Transaction, :count).from(1).to(0)
    end

    it 'calls the BuildDeckService' do
      expect(build_deck_service_instance).to receive(:call)
      subject.call
    end
  end
end
