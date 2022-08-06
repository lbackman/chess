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
        piece = config[file: j, rank: i][:piece]
        board[[j, i]].piece = piece[0].new(piece[1]) if piece
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

  def diagonal_attacks(color:, file:, rank:, range:)
    diagonals = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
    attacked = []
    diagonals.each do |diag|
      i = 1
      until i >= range ||
        !board[[file, rank].zip(diag.map { |n| n * i }).map(&:sum)] ||
        board[[file, rank].zip(diag.map { |n| n * i }).map(&:sum)].piece&.color
        attacked << board[[file, rank].zip(diag.map { |n| n * i }).map(&:sum)]
        if board[[file, rank].zip(diag.map { |n| n * (i+1) }).map(&:sum)].piece&.color &&
          board[[file, rank].zip(diag.map { |n| n * (i+1) }).map(&:sum)].piece&.color != color
          attacked << board[[file, rank].zip(diag.map { |n| n * (i+1) }).map(&:sum)]
        end
        i += 1
      end
    end
    attacked.map(&:piece)
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
b.populate_board
b.change_rank
puts b.print_board
b.change_rank(-1)
puts b.print_board
p b.diagonal_attacks(color: :black, range: 7, file: 1, rank: 4)