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

  def get_start_square(color)
    loop do
      next until handle_input
      start = choose_start
      return start if !start.nil? && start.piece_color == color
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
      long_castle(color)
    elsif start.file - destination.file == -2
      short_castle(color)
    end
  end

  def long_castle(color)
    temp_rook = board.board[board.rook_square(color, :long)].piece
    board.board[board.rook_square(color, :long)].piece = nil
    board.board[board.castle_square1(color, :long)].piece = temp_rook
  end

  def short_castle(color)
    temp_rook = board.board[board.rook_square(color, :short)].piece
    board.board[board.rook_square(color, :short)].piece = nil
    board.board[board.castle_square1(color, :short)].piece = temp_rook
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

# implement method that says "#{color} king in check" if in check
# if a piece is taken it should be announced: eg. White bishop takes black pawn.
# 
