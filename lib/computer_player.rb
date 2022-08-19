class ComputerPlayer
  attr_reader :color

  def initialize(color:)
    @color = color
  end

  def get_start_square(game, board, color)
    board.choosable_squares(color).sample
  end

  def get_destination_square(game, board, start)
    sleep(0.1)
    board.choosable_destinations(start).sample
  end
end
