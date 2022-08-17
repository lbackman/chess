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
# class EPPawn 
#   def initialize(pawn)
#     @pawn  = pawn
#     @color = pawn.color
#   end
# end


# in each play_round loop: board.pawns(color).all { |pawn| pawn.ep_vulernable = false }
# /not needed if counter increments to make it false after first check

# class Pawn
#   def post_initialize
#     @ep_counter = 0
#   end
#   attr_reader :ep_counter
#   def ep_vulnerable?(square, color)
#     @ep_counter += 1 if times_moved >= 1 # so the pawn is only vulnerable directly after
#     times_moved == 1 && ep_counter == 1 && (square.rank == 4 || square.rank == 5)
#   end
# end

# def pawn_attacks
#   #...
#   if add_square(file, rank, vector, 1)&.piece ||
#     ( add_square(file, rank, vector, 1)&.ep_pawn
#      && add_square(file, rank, vector, 1)&.piece.ep_vulnerable? )
#       attacked << add_square(file, rank, vector, 1)
#   end
#   # ...
# end

# ep_pawns must not be added to non-pawn-pieces' attack arrays

# Alternatively: 

# def choose_destination(start)
#   destination = board.current_square
#   piece = start.piece
#   case piece.name
#   when 'king'
#     return choose_king_destination(start) # castling conditions
#   when 'pawn'
#     return choose_pawn_destination(start) # en passant conditions
#   else
#     return destination if piece.available_moves.include?(destination.to_a)
#   end
# end

# Castling:

# def add_castling_moves(color)
#   add_long(color) if long_castling_allowed?(color)
#   add_short(color) if short_castling_allowed?(color)
# end

# def add_long(color)
#   king = king_square(color).piece
#   king.available_moves << color == :white ? [1, 7] : [8, 7]
# end

# Modify:
# def move_piece(start, destination)
#   board.move_piece(start.to_a, destination.to_a)
#   special_moves(start, destination)
# end

# def special_moves(start, destination)
#   if start == king_square
#     && destination == (long_square || short_square)
#     && castling_allowed?(king_square.piece_color)
#       do_castle_move(start, destination)
#   end
# end

# def do_castle_move(start, destination)
#   destination.piece = king
#   next_to_destination.piece = rook
#   start.piece = nil
#   rook_start.piece = nil
#   # king.times_moved already increments in the original move_piece method call
#   rook.times_moved += 1
# end

# def special_move(start, start_piece, destination, dest_piece)
#   if start_piece.name == 'pawn'
#     special_pawn_moves(start, destination, dest_piece)
#   end
#   if start_piece.name == 'king' && castling_allowed?
#     castle(start, destination)
#   end
# end

# def special_pawn_moves(start, destination, dest_piece)
#   if destination.rank == 8 || destination.rank == 1
#     promote_pawn(destination)
#   end
#   if (start.file - destination.rank) ** 2 == 1 && dest_piece.nil?
#     en_passant(start, destination)
#   end
# end

# def promote_pawn(destination)
#   pieces = Hash.new(Pi)
#   color = destination.piece_color
#   destination.piece = 

# def castle(start, destination)
# end

# Current player should only be able to select their own color pieces 