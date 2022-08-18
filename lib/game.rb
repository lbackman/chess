require_relative 'board'
require_relative 'input'

class Game
  # include Input::HumanPlayer
  
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

  def move_piece(start, destination)
    board.move_piece(start.to_a, destination.to_a)
  end

  def play_round(color)
    extend current_player.type # not working with two different player types...
    display
    start = get_start_square(color)
    start_piece = start.piece
    destination = get_destination_square(start)
    captured_piece = destination.piece
    move_piece(start, destination)
    special_move(start, start_piece, destination, captured_piece)
    increment_ep_count(color)
    display
  end

  def increment_ep_count(color)
    board
      .all_pawns(current_player.color)
      .each { |pawn| pawn.ep_counter += 1 if pawn.times_moved == 1 }
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
      break if game_over?

      change_player!
    end
    puts checkmate? ? "Checkmate!" : "Stalemate"
  end

  def game_over?
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

  def special_move(start, start_piece, destination, captured_piece)
    case start_piece.name
    when 'pawn'
      special_pawn_moves(start, start_piece, destination, captured_piece)
    when 'king'
      castling(start, start_piece.color, destination)
    end
  end

  def special_pawn_moves(start, start_piece, destination, captured_piece)
    if (destination.file - start.file) ** 2 == 1 && captured_piece.nil?
      board.en_passant(destination, start_piece)
    elsif destination.rank == 8 || destination.rank == 1
      board.promotion(destination, start_piece)
    end
  end

  def castling(start, color, destination)
    if start.file - destination.file == 2
      board.long_castle(color)
    elsif start.file - destination.file == -2
      board.short_castle(color)
    end
  end
end

Player = Struct.new(:color, :type, keyword_init: true)
p1 = Player.new(color: :white, type: Input::ComputerPlayer)
p2 = Player.new(color: :black, type: Input::ComputerPlayer)

initial_board_config = Pieces.config(:white, :black)
b = Board.new(config: initial_board_config)
b.populate_board
# b.set_all_available_moves(:white)
# b.change_rank
g = Game.new(players: [p1, p2], board: b)
# g.play_round(:black)
g.play_chess
# p g.choose_start

# implement method that says "#{color} king in check" if in check
# if a piece is taken it should be announced: eg. White bishop takes black pawn.
# 
