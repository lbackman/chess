require_relative 'square'
require_relative 'pieces'

class Board
  attr_reader :board, :config, :current_file, :current_rank
  def initialize(square: Square, config: {})
    @board = create_board(square)
    @config = config
    @current_file = 1
    @current_rank = 1
  end

  def create_board(square)
    board_hash = {}
    1.upto(8) do |i|
      1.upto(8) { |j| board_hash[[j,i]] = square.new(file: j, rank: i) }
    end
    board_hash
  end

  def populate_board
    1.upto(8) do |i|
      1.upto(8) do |j|
        board[[j, i]].piece = config[file: j, rank: i][:piece]
      end
    end
  end

  def current_square
    board[[current_file, current_rank]]
  end

  def change_file(amount = 0)
    board[[current_file, current_rank]].marked = false
    @current_file = 1 + (8 + current_file + amount - 1) % 8
    board[[current_file, current_rank]].marked = true
  end

  def change_rank(amount = 0)
    board[[current_file, current_rank]].marked = false
    @current_rank = 1 + (8 + current_rank + amount - 1) % 8
    board[[current_file, current_rank]].marked = true
  end

  def select_piece(coord)
    board[coord].piece
  end

  def move_piece(start, destination)
    piece = select_piece(start)
    board[start].piece = nil
    board[destination].piece = piece
  end

  def attacks(file:, rank:)
    return [] if board[[file, rank]].piece.nil?

    piece = board[[file, rank]].piece
    return pawn_attacks(file:, rank:, piece: piece) if piece.name == 'pawn'

    attacked = []
    piece.vectors.each do |vector|
      sub = []
      i = 1
      until i >= piece.range + 1 || !add_square(file, rank, vector, i) || sub.last&.piece
        sub << add_square(file, rank, vector, i)
        i += 1
      end
      sub.each { |el| attacked << el }
    end
    attacked.
      reject { |square| square.piece_color == piece.color }.
      map { |s| [s.file, s.rank] }
  end

  def pawn_attacks(file:, rank:, piece:)
    attacked = []
    piece.vectors[:move].each do |vector|
      i = 1
      while i <= piece.range && add_square(file, rank, vector, i).piece.nil?
        attacked << add_square(file, rank, vector, i)
        i += 1
      end
    end
    piece.vectors[:attack].each do |vector|
      if add_square(file, rank, vector, 1)&.piece
        attacked << add_square(file, rank, vector, 1)
      end
    end
    attacked.
      reject { |square| square.piece_color == piece.color }.
      map { |s| [s.file, s.rank] }
  end

  def add_square(file, rank, vector, range)
    board[[file, rank].zip(vector.map { |n| n * range }).map(&:sum)]
  end

  def print_upper_lower_rank(rank)
    1.upto(8).map { |i| board[[i, rank]].upper_lower_third }.join
  end

  def print_middle_rank(rank)
    1.upto(8).map { |i| board[[i, rank]].middle_third }.join
  end

  def print_rank(rank)
    print_upper_lower_rank(rank) + "\n" +
    print_middle_rank(rank)      + "\n" +
    print_upper_lower_rank(rank)
  end

  def print_board
    puts 8.downto(1).map { |i| print_rank(i) }.join("\n")
  end
end

initial_board_config = Pieces.config(:white, :black)

b = Board.new(config: initial_board_config)
# b.populate_board
# b.change_rank
# puts b.print_board
# b.change_rank(-1)
b.board[[4, 4]].piece = Pieces::Pawn.new(:white)
b.board[[4, 5]].piece = Pieces::Pawn.new(:black)
b.board[[2, 3]].piece = Pieces::Queen.new(:black)
b.board[[4, 2]].piece = Pieces::Knight.new(:white)
b.board[[1, 1]].piece = Pieces::Knight.new(:black)
b.board[[5, 4]].piece = Pieces::Rook.new(:white)
b.board[[6, 2]].piece = Pieces::King.new(:white)
b.board[[8, 8]].piece = Pieces::King.new(:black)
puts b.print_board
p b.attacks(file: 4, rank: 2)