require 'board'

SqrDbl = Struct.new(:file, :rank, :piece, :marked, keyword_init: true) do
  def initialize(*)
      super
      self.piece ||= nil
  end
end

class PieceDbl
  attr_reader :color
  def initialize(color)
    @color = color
  end
end

class PawnDbl < PieceDbl
end

RSpec.describe Board do
  describe '#initialize' do
    subject(:new_board) { described_class.new(square: SqrDbl) }
    let(:square) { SqrDbl.new(file: 1, rank: 2) }
    let(:square2) { SqrDbl.new(file: 3, rank: 4) }
    it 'creates a board' do
      expect(new_board.board[[1, 2]]).to eq(square)
      expect(new_board.board[[3, 4]]).to eq(square2)
    end
  end

  describe '#populate_board' do
    subject(:populated_board) { described_class.new(square: SqrDbl, config: double_config) }
    let(:double_config) { Hash.new(piece: nil).merge(
      { file: 1, rank: 2 } => { piece: [PawnDbl, 'white'] }) }
    before do
      populated_board.populate_board
    end

    context 'it places the pieces in the correct squares:' do
      it 'white pawn in file 1, rank 2' do
        piece = populated_board.board[[1, 2]].piece
        expect(piece).to be_kind_of(PawnDbl)
        expect(piece.color).to eq('white')
      end

      it 'no piece in file 4, rank 4' do
        piece = populated_board.board[[4, 4]].piece
        expect(piece).to be_nil
      end
    end
  end

  describe '#move_piece' do
    subject(:move_board) {  described_class.new(square: SqrDbl, config: double_config )}
    let(:double_config) { Hash.new(piece: nil).merge(
      { file: 1, rank: 2 } => { piece: [PawnDbl, 'white'] }) }
    context 'when moving a pawn from a2 to a4' do
      before do
        move_board.populate_board
        @piece = move_board.board[[1,2]].piece
        move_board.move_piece([1,2], [1,4])
      end

      it 'the pawn is at a4' do
        expect(move_board.board[[1,4]].piece).to eq(@piece)
      end

      it 'there is no piece at a2' do
        expect(move_board.board[[1,2]].piece).to be_nil
      end
    end
  end

  describe '#change_square' do
    subject(:change_board) { described_class.new(square: SqrDbl) }
    context 'changes instance variable @current_square' do
      it 'starts at square a1' do
        square = change_board.current_square
        expect(square).to be(change_board.board[[1, 1]])
      end

      it 'changes rank by 1' do
        change_board.change_rank(1)
        square = change_board.current_square
        expect(square).to be(change_board.board[[1, 2]])
      end

      it 'changes rank by 2 and file by 2' do
        2.times { change_board.change_rank(1) }
        2.times { change_board.change_file(1) }
        square = change_board.current_square
        expect(square).to be(change_board.board[[3, 3]])
      end

      it 'wraps around the board' do
        2.times { change_board.change_rank(-1) }
        2.times { change_board.change_file(-1) }
        square = change_board.current_square
        expect(square).to be(change_board.board[[7, 7]])
      end
    end
  end
end
