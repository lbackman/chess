require 'board'

SqrDbl = Struct.new(:file, :rank, :piece, :marked, keyword_init: true) do
  def initialize(*)
      super
      self.piece ||= nil
  end
end

class PieceDbl
  attr_reader :color, :name
  attr_accessor :times_moved, :available_moves
  def initialize(color)
    @color = color
    @name = ''
    @times_moved = 0
    @available_moves = []
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
      { file: 1, rank: 2 } => { piece: PawnDbl.new('white') }) }
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
      { file: 1, rank: 2 } => { piece: PawnDbl.new('white') }) }
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

  RSpec.shared_context 'attacking' do
    subject(:b) { described_class.new(square: Square) }
    before do
      b.board[[4, 4]].piece = Pieces::Pawn.new(:white)
      b.board[[4, 5]].piece = Pieces::Pawn.new(:black)
      b.board[[2, 3]].piece = Pieces::Queen.new(:black)
      b.board[[4, 2]].piece = Pieces::Knight.new(:white)
      b.board[[1, 1]].piece = Pieces::Knight.new(:black)
      b.board[[5, 4]].piece = Pieces::Rook.new(:white)
      b.board[[6, 2]].piece = Pieces::King.new(:white)
      b.board[[8, 8]].piece = Pieces::King.new(:black)
      b.board[[8, 2]].piece = Pieces::Pawn.new(:white)
      b.board[[8, 1]].piece = Pieces::Knight.new(:black)
      @wp_attacks = b.attacks(file: 4, rank: 4)
      @bp_attacks = b.attacks(file: 4, rank: 5)
      @bq_attacks = b.attacks(file: 2, rank: 3)
      @wn_attacks = b.attacks(file: 4, rank: 2)
      @bn_attacks = b.attacks(file: 1, rank: 1)
      @wr_attacks = b.attacks(file: 5, rank: 4)
      @wk_attacks = b.attacks(file: 6, rank: 2)
      @bk_attacks = b.attacks(file: 8, rank: 8)
      @p2_attacks = b.attacks(file: 8, rank: 2)
      @n2_attacks = b.attacks(file: 8, rank: 1)
    end
  end

  describe '#attacks' do
    include_context 'attacking'

    it 'white pawn on d4 has no moves' do
      expect(@wp_attacks.size).to eq(0)
    end

    it 'black queen on b3 can move to 19 squares' do
      expect(@bq_attacks.size).to eq(19)
    end

    it 'black queen on b3 is blocked by black pawn on d5' do
      expect(@bq_attacks).to include([3, 4])
      expect(@bq_attacks).to_not include([4, 5])
    end

    it 'black knight on a1 is blocked by black queen b3' do
      expect(@bn_attacks).to eq([[3, 2]])
    end

    it 'white knight on d2 can take black queen b3' do
      expect(@wn_attacks).to include([2,3])
    end

    it 'black pawn on d5 can take white rook on e4 and only that square' do
      expect(@bp_attacks).to eq [[5, 4]]
    end

    it 'white king on f2 attacks all 8 adjacent squares' do
      expect(@wk_attacks.size).to eq(8)
    end

    it 'black king on h8 attacks 3 adjacent squares' do
      expect(@bk_attacks.size).to eq(3)
    end

    it 'white pawn on g7 can move one or two steps forward' do
      expect(@p2_attacks).to eq([[8, 3], [8, 4]])
    end
  end

  describe '#king_checked?' do
    include_context 'attacking'

    it 'white king is in check' do
      expect(b.king_checked?(:white)).to be_truthy
    end

    it 'black king is not in check' do
      expect(b.king_checked?(:black)).to be_falsey
    end
  end

  describe '#castling_allowed?' do
    subject(:c_board) { described_class.new(square: Square) }
    let(:w_king)      { PieceDbl.new(:white) } 
    let(:w_rook1)     { PieceDbl.new(:white) }
    let(:w_rook2)     { PieceDbl.new(:white) }
    let(:b_queen)     { PieceDbl.new(:black) }
    let(:w_knight)    { PieceDbl.new(:white) }

    context 'when all conditions are met' do

      before do
        allow(w_rook1).to receive(:available_moves).and_return([[4, 1]])
        allow(w_rook2).to receive(:available_moves).and_return([[6, 1]])
        allow(w_king).to receive(:name).and_return('king')
      end

      it 'white king can long castle' do
        c_board.board[[5, 1]].piece = w_king
        c_board.board[[1, 1]].piece = w_rook1
        long_castle_rights = c_board.castling_allowed?(:white, :long)
        expect(long_castle_rights).to be_truthy
      end

      it 'white king can short castle' do
        c_board.board[[5, 1]].piece = w_king
        c_board.board[[8, 1]].piece = w_rook2
        short_castle_rights = c_board.castling_allowed?(:white, :short)
        expect(short_castle_rights).to be_truthy
      end
    end

    context 'when the king or rook has moved at least once' do
      before do
        allow(w_rook1).to receive(:available_moves).and_return([[4, 1]])
        w_rook1.times_moved = 2
        allow(w_king).to receive(:name).and_return('king')
      end

      it 'white king can not castle' do
        c_board.board[[5, 1]].piece = w_king
        c_board.board[[1, 1]].piece = w_rook1
        long_castle_rights = c_board.castling_allowed?(:white, :long)
        expect(long_castle_rights).to be_falsey
      end
    end

    context 'when the king is in check' do
      before do
        allow(w_rook1).to receive(:available_moves).and_return([[4, 1]])
        allow(b_queen).to receive(:available_moves).and_return([[5, 1]])
        allow(c_board).to receive(:king_checked?).with(:white).and_return(true)
        allow(w_king).to receive(:name).and_return('king')
      end

      it 'white king can not castle' do
        c_board.board[[5, 1]].piece = w_king
        c_board.board[[1, 1]].piece = w_rook1
        c_board.board[[5, 4]].piece = b_queen
        long_castle_rights = c_board.castling_allowed?(:white, :long)
        expect(long_castle_rights).to be_falsey
      end
    end

    context 'when the square the king must move over is attacked' do
      before do
        allow(w_rook1).to receive(:available_moves).and_return([[4, 1]])
        allow(b_queen).to receive(:available_moves).and_return([[6, 1]])
        allow(c_board).to receive(:castle_square_attacked?).with(:white, :long).and_return(true)
        allow(c_board).to receive(:king_checked?).with(:white).and_return(false)
        allow(w_king).to receive(:name).and_return('king')
      end

      it 'white king can not castle' do
        c_board.board[[5, 1]].piece = w_king
        c_board.board[[1, 1]].piece = w_rook1
        c_board.board[[6, 4]].piece = b_queen
        long_castle_rights = c_board.castling_allowed?(:white, :long)
        expect(long_castle_rights).to be_falsey
      end
    end
  end
end
