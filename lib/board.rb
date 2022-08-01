require_relative 'square'

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
        board[[j, i]].piece = config[file: j, rank: i][:piece][0].new(
          config[file: j,rank: i][:piece][1]) if config[file: j, rank: i][:piece]
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

  def diagonals(file, rank)
    diagonal = []
    1.upto(7) do |i|
      diagonal << board[[file + i, rank + i]] # up-right diagonal
      diagonal << board[[file + i, rank - i]] # down-right diagonal
      diagonal << board[[file - i, rank - i]] # down-left diagonal
      diagonal << board[[file - i, rank + i]] # up-left diagonal
    end
    diagonal.compact
  end

  def diagonal_ur(file, rank) # Up and to the Right
    diagonals = []
    i = 0
    until board[[file + i + 1, rank + i + 1]].nil? || board[[file + i, rank + i]].piece
      i += 1
      diagonals << board[[file + i, rank + i]]
    end
    diagonals
  end
end

class Piece
  attr_reader :color
  def initialize(color)
    @color = color
  end
end

class Pawn < Piece
end

class Knight < Piece
end

class Bishop < Piece
end

class Rook < Piece
end

class Queen < Piece
end

class King < Piece
end

initial_board_config = Hash.new(piece: nil).merge(
  { file: 1, rank: 1 } => { piece: [Rook,   'white'] },
  { file: 2, rank: 1 } => { piece: [Knight, 'white'] },
  { file: 3, rank: 1 } => { piece: [Bishop, 'white'] },
  { file: 4, rank: 1 } => { piece: [Queen,  'white'] },
  { file: 5, rank: 1 } => { piece: [King,   'white'] },
  { file: 6, rank: 1 } => { piece: [Bishop, 'white'] },
  { file: 7, rank: 1 } => { piece: [Knight, 'white'] },
  { file: 8, rank: 1 } => { piece: [Rook,   'white'] },
  { file: 1, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 2, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 3, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 4, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 5, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 6, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 7, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 8, rank: 2 } => { piece: [Pawn,   'white'] },
  { file: 1, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 2, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 3, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 4, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 5, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 6, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 7, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 8, rank: 7 } => { piece: [Pawn,   'black'] },
  { file: 1, rank: 8 } => { piece: [Rook,   'black'] },
  { file: 2, rank: 8 } => { piece: [Knight, 'black'] },
  { file: 3, rank: 8 } => { piece: [Bishop, 'black'] },
  { file: 4, rank: 8 } => { piece: [Queen,  'black'] },
  { file: 5, rank: 8 } => { piece: [King,   'black'] },
  { file: 6, rank: 8 } => { piece: [Bishop, 'black'] },
  { file: 7, rank: 8 } => { piece: [Knight, 'black'] },
  { file: 8, rank: 8 } => { piece: [Rook,   'black'] } )
