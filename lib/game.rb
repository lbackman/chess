# frozen_string_literal: true

# lib/game.rb

require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'
require_relative 'save'
require_relative 'messages'

# handles game events
class Game
  include Messages
  include Save

  attr_reader :board, :players
  attr_accessor :move_message, :turn_message, :check_message, :end_message, :save_message

  def initialize(players: [nil, nil])
    @players        = players
    @board          = set_up_board

    @move_message   = 'White to move'
    @turn_message   = ''
    @check_message  = ''
    @save_message   = ''
  end

  def play_chess
    system('clear')
    loop do
      set_up_and_play
      break if game_over?

      change_player!
    end
    end_of_game
  end

  def display
    board.print_board
    puts move_message
    puts turn_message
    puts check_message
    print save_message
  end

  def set_up_and_play
    board.set_all_available_moves(current_player.color)
    play_round(current_player.color)
    board.set_all_available_moves(next_player.color)
  end

  def change_player!
    @players.rotate!
  end

  def current_player
    players.first
  end

  def next_player
    players.last
  end

  def game_over?
    checkmate? || stalemate?
  end

  def move_piece(start, destination)
    board.move_piece(start.to_a, destination.to_a)
  end

  private

  def set_up_board
    board = Board.new(config: Pieces.config(:white, :black))
    board.populate_board
    board
  end

  def play_round(color)
    display
    start = current_player.get_start_square(board, self)
    start_piece = start.piece
    destination = current_player.get_destination_square(board, start, self)
    captured_piece = destination.piece
    move_piece(start, destination)
    after_move(start_piece, start, destination, captured_piece, color)
  end

  def after_move(start_piece, start, destination, captured_piece, color)
    clear_messages
    @move_message = movements_message(start_piece, start, destination, captured_piece)
    @turn_message = whose_turn(color)
    special_move(start, start_piece, destination, captured_piece)
    @check_message = check(color)
    increment_ep_count
    display
  end

  def clear_messages
    @move_message  = "\033[K" # Erase to end of line
    @turn_message  = "\033[K"
    @check_message = "\033[K"
    @save_message  = "\033[K"
    display
  end

  def increment_ep_count
    board
      .all_pawns(current_player.color)
      .each { |pawn| pawn.ep_counter += 1 if pawn.times_moved == 1 }
  end

  def end_of_game
    puts checkmate? ? mate_message : stalemate_message
    puts win_message(current_player.color)
  end

  def checkmate?
    color = next_player.color
    board.king_checked?(color) &&
      board.squares(color).all? { |square| square[1].legal_piece_moves.empty? }
  end

  def stalemate?
    color = next_player.color
    !board.king_checked?(color) &&
      board.squares(color).all? { |square| square[1].legal_piece_moves.empty? }
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
    if (destination.file - start.file)**2 == 1 && captured_piece.nil?
      @move_message = ep_message(start, destination, start_piece)
      board.en_passant(destination, start_piece)
    elsif destination.rank == 8 || destination.rank == 1
      board.promotion(destination, start_piece)
      @move_message = promotion_message(move_message, destination.piece)
    end
  end

  def castling(start, color, destination)
    case start.file - destination.file
    when 2
      board.castle(color, :long)
      @move_message = long_castle_message(destination.piece)
    when -2
      board.castle(color, :short)
      @move_message = short_castle_message(destination.piece)
    end
  end
end
