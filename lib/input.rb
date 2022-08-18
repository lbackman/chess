require 'io/console'

module Input

  module HumanPlayer
    def handle_direction_input
      case $stdin.getch
      when 'A' then board.change_rank(1)
      when 'B' then board.change_rank(-1)
      when 'D' then board.change_file(-1)
      when 'C' then board.change_file(1)
      end
      display # show display to update cursor position
      false
    end

    def handle_input
      case $stdin.getch
      when "\r" then true
      when '[' then handle_direction_input
      when "q" then exit
      when "s" then puts 'save game'
      when 'r' then
        puts 'resign'
        exit
      end
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
  end

  module ComputerPlayer
    def get_start_square(color)
      board.choosable_squares(color).sample
    end

    def get_destination_square(start)
      sleep(0.1)
      board.choosable_destinations(start).sample
    end
  end

end
