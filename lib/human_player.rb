# frozen_string_literal: true

# lib/human_player.rb

require 'io/console'

# handles input from human player
class HumanPlayer
  attr_reader :color

  def initialize(color:)
    @color = color
  end

  def handle_direction_input(board, game)
    case $stdin.getch
    when 'A' then board.change_rank(1)
    when 'B' then board.change_rank(-1)
    when 'D' then board.change_file(-1)
    when 'C' then board.change_file(1)
    end
    game.display # show display to update cursor position
    false
  end

  def handle_input(board, game)
    case $stdin.getch
    when "\r" then true
    when '[' then handle_direction_input(board, game)
    when 'q' then exit
    when 's' then game.save_game
    when 'r'
      puts 'resign'
      exit
    end
  end

  def choose_start(board)
    start = board.current_square
    return start if start&.legal_piece_moves && !start.legal_piece_moves.empty?
  end

  def choose_destination(board, start)
    destination = board.current_square
    piece = start.piece
    return destination if piece.available_moves.include?(destination.to_a)
  end

  def get_start_square(board, game)
    loop do
      next until handle_input(board, game)
      start = choose_start(board)
      return start if !start.nil? && start.piece_color == color
    end
  end

  def get_destination_square(board, start, game)
    loop do
      next until handle_input(board, game)
      destination = choose_destination(board, start)
      return destination unless destination.nil?
    end
  end
end
