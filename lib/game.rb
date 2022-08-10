require_relative 'board'
require_relative 'game_input'

class Game
  include GameInput
  attr_reader :board, :current_player, :next_player
  def initialize(players: [nil, nil], board: nil)
    @player_1       = players.first
    @player_2       = players.last
    @board          = board
    @current_player = @player_1
    @next_player    = @player_2
  end

  def change_player!
    @current_player, @next_player = next_player, current_player
  end

  def choose_start
    start = board.current_square
    piece = start.piece
    return start if piece&.available_moves && !piece.available_moves.empty?
  end

  def choose_destination(start)
    destination = board.current_square
    piece = start.piece
    return destination if piece.available_moves.include?(destination.to_a)
  end

  def move_piece(start, destination)
    board.move_piece(start.to_a, destination.to_a)
  end

  def get_start_square
    loop do
      next until handle_input
      start = choose_start
      return start unless start.nil?
    end
  end

  def get_destination_square(start)
    loop do
      next until handle_input
      destination = choose_destination(start)
      return destination unless destination.nil?
    end
  end

  def play_round(color)
    display
    start = get_start_square
    destination = get_destination_square(start)
    move_piece(start, destination)
    display
  end

  def display
    system('clear')
    # puts "\n\n"
    board.print_board
    # puts "\n\n"
  end

  def play_chess
    loop do
      board.set_all_available_moves(current_player.color)
      play_round(current_player.color)
      board.set_all_available_moves(next_player.color)
      break if endgame?

      change_player!
    end
    puts checkmate? ? "Checkmate!" : "Stalemate"
  end

  def endgame?
    checkmate? || stalemate?
  end

  def checkmate?
    color = next_player.color
    board.king_checked?(color) && board.squares(color).all? { |square| square[1].piece.available_moves.empty?}
  end

  def stalemate?
    color = next_player.color
    !board.king_checked?(color) && board.squares(color).all? { |square| square[1].piece.available_moves.empty?}
  end
end

Player = Struct.new(:color, keyword_init: true)
p1 = Player.new(color: :white)
p2 = Player.new(color: :black)

initial_board_config = Pieces.config(:white, :black)
b = Board.new(config: initial_board_config)
b.populate_board
# b.set_all_available_moves(:white)
b.change_rank
g = Game.new(players: [p1, p2], board: b)
# g.play_round(:black)
g.play_chess
# p g.choose_start