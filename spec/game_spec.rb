require 'game'

RSpec.describe Game do
  subject(:new_game) { described_class.new(players: ['p1', 'p2'], board: board)}
  describe '#move_piece' do
    let(:board) { double('board') }

    it 'sends message to Board' do
      expect(board).to receive(:move_piece).with(piece: nil, destination: nil)
      new_game.move_piece(piece: nil, destination: nil)
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
