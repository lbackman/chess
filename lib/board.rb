# frozen_string_literal: true

# lib/board.rb

require_relative 'square'
require_relative 'pieces'
require_relative 'board_presentation'

# manages moves on chessboard
class Board
  include BoardPresentation

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
      1.upto(8) { |j| board_hash[[j, i]] = square.new(file: j, rank: i) }
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
    case piece.name
    when 'pawn'
      pawn_attacks(file: file, rank: rank, pawn: piece)
    else
      default_attacks(file: file, rank: rank, piece: piece)
    end
  end

  def default_attacks(file:, rank:, piece:)
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
    attacked.reject { |square| square.piece_color == piece.color }.map { |s| [s.file, s.rank] }
  end

  def pawn_attacks(file:, rank:, pawn:)
    attacked = []
    pawn_moves(file: file, rank: rank, pawn: pawn, arr: attacked)
    pawn_captures(file: file, rank: rank, pawn: pawn, arr: attacked)
    attacked.reject { |square| square.piece_color == pawn.color }.map { |s| [s.file, s.rank] }
  end

  def pawn_moves(file:, rank:, pawn:, arr:)
    pawn.vectors[:move].each do |vector|
      i = 1
      while i <= pawn.range && add_square(file, rank, vector, i).piece.nil?
        arr << add_square(file, rank, vector, i)
        i += 1
      end
    end
  end

  def pawn_captures(file:, rank:, pawn:, arr:)
    pawn.vectors[:capture].each do |vector|
      dest = add_square(file, rank, vector, 1)
      ep_capture = ep_square(dest, pawn)&.piece if dest
      if dest&.piece || ep_capture&.ep_vulnerable?(dest.rank - pawn.direction)
        arr << add_square(file, rank, vector, 1)
      end
    end
  end

  def add_square(file, rank, vector, range)
    board[[file, rank].zip(vector.map { |n| n * range }).map(&:sum)]
  end

  def squares(color)
    board.select { |_k, v| v.piece_color == color }
  end

  def king_coord(color)
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

  def set_available_castles(color)
    king = board[king_coord(color)].piece
    available = []
    %i[long short].each do |type|
      available << castle_coord2(color, type) if castling_allowed?(color, type)
    end
    available.each { |move| king.available_moves << move }
  end

  def set_all_available_moves(color)
    attack_hash = all_attacks(color)
    attack_hash.each { |k, v| set_available_moves(k.last, k.first, v) }
    set_available_castles(color)
  end

  def king_checked?(color)
    all_attacks(other_color(color)).any? { |_k, v| v.include?(king_coord(color)) }
  end

  def other_color(color)
    { white: :black, black: :white }[color]
  end

  def all_pawns(color)
    squares(color).select { |_k, v| v.piece_name == 'pawn' }.map { |_k, v| v.piece }
  end

  def ep_square(square, pawn)
    board[[square.file, square.rank - pawn.direction]]
  end

  def en_passant(destination, pawn)
    ep_square(destination, pawn).piece = nil
  end

  def promotion(destination, pawn)
    destination.piece = Pieces::Queen.new(pawn.color)
  end

  def castling_allowed?(color, type)
    !king_checked?(color) &&
      board[king_coord(color)]&.piece_moved&.zero? &&
      board[rook_coord(color, type)]&.piece_moved&.zero? &&
      castle_squares_unattacked?(color, type) &&
      board[rook_coord(color, type)].legal_piece_moves.include?(castle_coord1(color, type))
  end

  def rook_coord(color, type)
    { white: { long: [1, 1], short: [8, 1] }, black: { long: [1, 8], short: [8, 8] } }[color][type]
  end

  def castle_coord1(color, type)
    { white: { long: [4, 1], short: [6, 1] }, black: { long: [4, 8], short: [6, 8] } }[color][type]
  end

  def castle_coord2(color, type)
    { white: { long: [3, 1], short: [7, 1] }, black: { long: [3, 8], short: [7, 8] } }[color][type]
  end

  def castle_squares_unattacked?(color, type)
    !(standard_piece_attack?(color, type) || pawn_attack?(color, type))
  end

  def standard_piece_attack?(color, type)
    squares = [castle_coord1(color, type), castle_coord2(color, type)]
    squares.any? do |square|
      all_attacks(other_color(color)).any? { |_k, v| v.include?(square) }
    end
  end

  def pawn_attack?(color, type)
    rank = { white: 2, black: 7 }[color]
    range = { long: (1..5), short: (5..8) }[type]
    range.map { |i| board[[i, rank]] }.any? { |sq| sq.piece_name == 'pawn' && sq.piece_color == other_color(color) }
  end

  def castle(color, type)
    temp_rook = board[rook_coord(color, type)].piece
    board[rook_coord(color, type)].piece = nil
    board[castle_coord1(color, type)].piece = temp_rook
  end
end
