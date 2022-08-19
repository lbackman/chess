require 'io/console'

class HumanPlayer
  attr_reader :color

  def initialize(color:)
    @color = color
  end

  def handle_direction_input(game, board)
    case $stdin.getch
    when 'A' then board.change_rank(1)
    when 'B' then board.change_rank(-1)
    when 'D' then board.change_file(-1)
    when 'C' then board.change_file(1)
    end
    game.display # show display to update cursor position
    false
  end

  def handle_input(game, board)
    case $stdin.getch
    when "\r" then true
    when '[' then handle_direction_input(game, board)
    when "q" then exit
    when "s" then puts 'save game'
    when 'r' then
      puts 'resign'
      exit
    end
  end

  def choose_start(board)
    start = board.current_square
    piece = start.piece
    return start if piece&.available_moves && !piece.available_moves.empty?
  end

  def choose_destination(board, start)
    destination = board.current_square
    piece = start.piece
    return destination if piece.available_moves.include?(destination.to_a)
  end

  def get_start_square(game, board, color)
    loop do
      next until handle_input(game, board)
      start = choose_start(board)
      return start if !start.nil? && start.piece_color == color
    end
  end

  def get_destination_square(game, board, start)
    loop do
      next until handle_input(game, board)
      destination = choose_destination(board, start)
      return destination unless destination.nil?
    end
  end
end
