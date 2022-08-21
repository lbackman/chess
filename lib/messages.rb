#output messages
module Messages
  def introduction
    <<~INTRO

    Welcome to Ruby Chess. Please select your player types and colors.

    INTRO
  end

  def check(color)
    col = board.other_color(color)
    board.king_checked?(col) ? "#{col.to_s.capitalize} king is checked!" : ""
  end

  def invalid_square
    "You must choose a piece that has legal moves."
  end

  def mate_message
    "Checkmate!"
  end

  def win_message(color)
    "#{color.to_s.capitalize} wins the game"
  end

  def stalemate_message
    "The game ends in stalemate"
  end

  def movements_message(piece, start, destination, captured_piece)
    "#{piece} moves from #{start} to #{destination}" + capture_message(captured_piece)
  end

  def capture_message(captured_piece)
    captured_piece ? " and takes #{captured_piece}" : ""
  end

  def whose_turn(color)
    "#{{white: :black, black: :white}[color].to_s.capitalize} to move"
  end

  def ep_message(start, destination, pawn, captured)
    "#{pawn} moves from #{start} to #{destination} and takes " +
    "#{board.ep_square(destination, pawn).piece} en passant"
  end

  def promotion_message(message, color)
    message + " and promotes to #{{ white: "\u2655", black: "\u265b" }[color]}"
  end

  def long_castle_message(king)
    "#{king} castles queenside"
  end

  def short_castle_message(king)
    "#{king} castles kingside"
  end
end
