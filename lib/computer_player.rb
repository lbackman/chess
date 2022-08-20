class ComputerPlayer
  attr_reader :color

  def initialize(color:)
    @color = color
  end

  def get_start_square(_game = nil, board)
    choosable_squares(color, board).sample
  end

  def get_destination_square(_game = nil, board, start)
    sleep(0.1)
    choosable_destinations(start, board).sample
  end

  private

  def choosable_squares(color, board)
    board.squares(color).select { |_k, v| !v.legal_piece_moves&.empty? }.values
  end

  def choosable_destinations(square, board)
    square.legal_piece_moves.each_with_object([]) { |m, o| o << board.board[m] }
  end
end
