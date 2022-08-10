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
    board.each { |k, v| v.piece = config[file: k.first, rank: k.last][:piece] }
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
    piece.times_moved += 1
  end

  def undo_move(destination, start, temp_piece)
    piece = select_piece(destination)
    board[start].piece = piece
    board[destination].piece = temp_piece
    piece.times_moved -= 1
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
    attacked.reject { |square| square.piece_color == piece.color }
      # .map(&:to_s)
      .map { |s| [s.file, s.rank] }
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
    attacked.reject { |square| square.piece_color == piece.color }
      # .map(&:to_s)
      .map { |s| [s.file, s.rank] }
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

  def squares(color)
    board.select { |_k, v| v.piece_color == color }
  end
  
  def king_square(color)
    squares(color).each_value.select { |v| v.piece_name == 'king' }.first.to_a
  end

  def all_attacks(color)
    attacked = {}
    squares(color).each do |k, v|
      attacked[[k, v.piece]] = attacks(file: v.file, rank: v.rank)
    end
    attacked
  end

  def set_available_moves(piece, start, piece_attacks)
    available = []
    piece_attacks.each do |dest|
      temp_piece = board[dest].piece
      move_piece(start, dest)
      available << dest unless king_checked?(piece.color)
      undo_move(dest, start, temp_piece)
    end
    piece.available_moves = available
  end

  def set_all_available_moves(color)
    attack_hash = all_attacks(color)
    attack_hash.each { |k, v| set_available_moves(k.last, k.first, v) }
  end

  def king_checked?(color)
    all_attacks(other_color(color))
      .any? { |_k, v| v.include?(king_square(color)) }
  end

  def other_color(color)
    { white: :black, black: :white }[color]
  end
end

# initial_board_config = Pieces.config(:white, :black)

# b = Board.new(config: initial_board_config)
# b.populate_board
# b.change_rank
# puts b.print_board
# b.change_rank(-1)
# b.board[[4, 4]].piece = Pieces::Pawn.new(:white)
# b.board[[4, 5]].piece = Pieces::Pawn.new(:black)
# b.board[[2, 3]].piece = Pieces::Queen.new(:black)
# b.board[[4, 2]].piece = Pieces::Knight.new(:white)
# b.board[[1, 1]].piece = Pieces::Knight.new(:black)
# b.board[[5, 4]].piece = Pieces::Rook.new(:white)
# b.board[[6, 2]].piece = Pieces::King.new(:white)
# b.board[[8, 8]].piece = Pieces::King.new(:black)
# b.board[[8, 2]].piece = Pieces::Pawn.new(:white)
# b.board[[8, 1]].piece = Pieces::Bishop.new(:black)
# b.board[[8, 4]].piece = Pieces::Rook.new(:white)
# b.board[[7, 5]].piece = Pieces::Pawn.new(:black)
# b.print_board
# p b.attacks(file: 8, rank: 1)
# b.squares(:white).each_value { |v| puts v }
# p b.squares(:white)
# p b.king_square(:white)
# puts b.king_checked?(:white)
# puts b.king_checked?(:black)
# p b.all_attacks(:black)
# b.set_all_available_moves(:black)
# b.set_all_available_moves(:white)
# p b.board[[6, 2]].piece.available_moves
