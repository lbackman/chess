# frozen_string_literal: true

# output messages
module Messages
  def logo
    <<~LOGO
      ██████  ██    ██ ██████  ██    ██
      ██   ██ ██    ██ ██   ██  ██  ██
      ██████  ██    ██ ██████    ████
      ██   ██ ██    ██ ██   ██    ██
      ██   ██  ██████  ██████     ██

      .d8888b.   888
      d88P  Y88b 888
      888    888 888
      888        88888b.   .d88b.  .d8888b  .d8888b
      888        888 "88b d8P  Y8b 88K      88K
      888    888 888  888 88888888 "Y8888b. "Y8888b.
      Y88b  d88P 888  888 Y8b.          X88      X88
      "Y8888P"   888  888  "Y8888   88888P'  88888P'
    LOGO
  end

  def main_menu_message
    <<~MENU

      #{logo}


      [N] >> New game
      #{load_game_message}
      [Q] >> Exit game




    MENU
  end

  def new_game_message
    <<~NEWGAME

      #{logo}

      Choose game setup:

      [1] >> Human against human
      [2] >> Human against computer

      [E] >> Back to main menu
      [Q] >> Exit game

    NEWGAME
  end

  def load_game_message
    saved_games.empty? ? '' : '[L] >> Load game'
  end

  def invalid_message
    'Invalid input'
  end

  def games_found
    'Games Found:'
  end

  def enter_save_file
    'Choose saved game '
  end

  def not_found
    'Not found'
  end

  def game_over_instructions
    'Press [M] to go back to the main menu, to exit, press any other key'
  end

  def check(color)
    col = board.other_color(color)
    board.king_checked?(col) ? "#{col.to_s.capitalize} king is checked!" : ''
  end

  def invalid_square
    'You must choose a piece that has legal moves.'
  end

  def mate_message
    'Checkmate!'
  end

  def win_message(color)
    "#{color.to_s.capitalize} wins the game"
  end

  def stalemate_message
    'The game ends in stalemate'
  end

  def movements_message(piece, start, destination, captured_piece)
    "#{piece} moves from #{start} to #{destination}" + capture_message(captured_piece)
  end

  def capture_message(captured_piece)
    captured_piece ? " and takes #{captured_piece}" : ''
  end

  def whose_turn(color)
    "#{{ white: :black, black: :white }[color].to_s.capitalize} to move"
  end

  def ep_message(start, destination, pawn)
    "#{pawn} moves from #{start} to #{destination} and takes " \
      "#{board.ep_square(destination, pawn).piece} en passant"
  end

  def promotion_message(message, queen)
    message + " and promotes to #{queen}"
  end

  def long_castle_message(king)
    "#{king} castles queenside"
  end

  def short_castle_message(king)
    "#{king} castles kingside"
  end
end
