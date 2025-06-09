require 'rails_helper'

RSpec.describe BuildDeckService do
  describe '#call' do
    subject { described_class.new }

    it 'creates a complete deck' do
      expect {
        subject.call
      }.to change(Card, :complete_deck?).from(false).to(true)
    end
  end
end
