# frozen_string_literal: true

# spec/game_spec.rb

require 'game'

RSpec.describe Game do
  describe '#move_piece' do
    subject(:new_game) { described_class.new(players: %w[p1 p2]) }
    let(:board) { double('board') }
    let(:start) { double('square') }
    let(:destination) { double('square') }
    before { allow(start).to receive(:to_a) }
    before { allow(destination).to receive(:to_a) }

    it 'sends message to Board' do
      allow_any_instance_of(Game).to receive(:set_up_board).and_return(board)
      expect(board).to receive(:move_piece).with(start.to_a, destination.to_a)
      new_game.move_piece(start, destination)
    end
  end

  describe '#change_player!' do
    subject(:game) { described_class.new(players: [player1, player2]) }
    let(:player1) { double('player') }
    let(:player2) { double('player') }
    context 'when the current player is player_1' do
      it 'changes to p2' do
        expect { game.change_player! }.to change { game.current_player }.to(player2)
      end
    end

    context 'when the current player is player_2' do
      before { game.change_player! }

      it 'changes to p1' do
        expect { game.change_player! }.to change { game.current_player }.to(player1)
      end
    end
  end
end
