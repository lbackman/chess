# frozen_string_literal: true

# spec/computer_player_spec.rb

require 'computer_player'

RSpec.describe ComputerPlayer do
  subject(:computer) { described_class.new(color: color) }
  let(:color) { :white }
  let(:board) { double('board') }
  let(:square) { double('square') }

  describe '#get_start_square' do
    before { allow(computer).to receive(:choosable_squares).and_return(%w[move1 move2]) }

    it 'chooses a random move' do
      move = computer.get_start_square(board)
      expect(%w[move1 move2]).to include(move)
    end
  end

  describe '#get_destination_square' do
    before do
      allow(computer).to receive(:sleep)
      allow(computer).to receive(:choosable_destinations).and_return(%w[dest1 dest2])
    end

    it 'chooses a random destination' do
      destination = computer.get_destination_square(board, square)
      expect(%w[dest1 dest2]).to include(destination)
    end
  end
end
