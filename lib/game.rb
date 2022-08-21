require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'messages'

class Game
  include Messages
  
  attr_reader :board, :current_player, :next_player
  attr_accessor :move_message, :turn_message, :check_message, :end_message
  def initialize(players: [nil, nil], board: nil)
    @player_1       = players.first
    @player_2       = players.last
    @board          = board

    @current_player = @player_1
    @next_player    = @player_2
    @move_message   = " " * 80
    @turn_message   = " " * 80
    @check_message  = " " * 80
  end

  def change_player!
    @current_player, @next_player = next_player, current_player
  end

  def move_piece(start, destination)
    board.move_piece(start.to_a, destination.to_a)
  end

  def play_round(color)
    display
    start = current_player.get_start_square(self, board)
    start_piece = start.piece
    destination = current_player.get_destination_square(self, board, start)
    captured_piece = destination.piece
    move_piece(start, destination)
    clear_messages
    @move_message = movements_message(start_piece, start, destination, captured_piece)
    @turn_message = whose_turn(color)
    @check_message = check(color)
    special_move(start, start_piece, destination, captured_piece)
    increment_ep_count(color)
    display
  end

  def clear_messages
    @move_message  = " " * 80
    @turn_message  = " " * 80
    @check_message = " " * 80
    display
  end

  def increment_ep_count(color)
    board
      .all_pawns(current_player.color)
      .each { |pawn| pawn.ep_counter += 1 if pawn.times_moved == 1 }
  end

  def display
    board.print_board
    puts move_message
    puts turn_message
    puts check_message
  end

  def play_chess
    system('clear')
    loop do
      board.set_all_available_moves(current_player.color)
      play_round(current_player.color)
      board.set_all_available_moves(next_player.color)
      break if game_over?

      change_player!
    end
    puts checkmate? ? mate_message : stalemate_message
    puts win_message(current_player.color)
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
      @move_message = ep_message(start, destination, start_piece, captured_piece)
      board.en_passant(destination, start_piece)
    elsif destination.rank == 8 || destination.rank == 1
      board.promotion(destination, start_piece)
      @move_message = promotion_message(move_message, start_piece.color)
    end
  end

  def castling(start, color, destination)
    if start.file - destination.file == 2
      board.castle(color, :long)
      @move_message = long_castle_message(destination.piece)
    elsif start.file - destination.file == -2
      board.castle(color, :short)
      @move_message = short_castle_message(destination.piece)
    end
  end
end

Player = Struct.new(:color, :type, keyword_init: true)
p1 = HumanPlayer.new(color: :white)#, type: Input::ComputerPlayer)
p2 = HumanPlayer.new(color: :black)#, type: Input::ComputerPlayer)

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
