class Game
  attr_reader :board, :current_player, :next_player
  def initialize(players: nil, board: nil)
    @player_1       = players.first
    @player_2       = players.last
    @board          = board
    @current_player = @player_1
    @next_player    = @player_2
  end

  def move_piece(piece: nil, destination: nil)
    board.move_piece(piece:, destination:)
  end
end
