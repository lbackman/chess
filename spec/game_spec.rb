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
end
