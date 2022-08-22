require_relative 'game'
require_relative 'save'

class Chess
  include Messages
  include Save
  attr_reader :saved_games

  def initialize
    @saved_games = read_saved_games
  end

  def main_menu
    system('clear')
    puts main_menu_message
    choice = $stdin.getch
    case choice
    when 'n' then game_setup
    when 'l' then load_saved_game
    when 'q' then exit
    else
      main_menu
    end
    game_over_prompt
  end

  def game_setup
    system('clear')
    puts new_game_message
    choice = $stdin.getch
    case choice
    when '1' then human_vs_human
    when '2' then human_vs_computer
    when '3' then computer_vs_computer
    when 'e' then main_menu
    when 'q' then exit
    else
      game_setup
    end
  end

  def choose_saved_game
    print enter_save_file
    name = gets.chomp
    if saved_games.keys.include?(name)
      saved_games[name].play_chess
    else
      puts not_found
      choose_saved_game
    end
  end

  def load_saved_game
    puts games_found
    saved_games.each_key { |name| puts name }
    choose_saved_game
  end

  def game_over_prompt
    puts game_over_instructions
    choice = $stdin.getch
    case choice
    when 'm' then main_menu
    else
      exit
    end
  end

  def human_vs_human
    Game.new(
        players: [HumanPlayer.new(color: :white), 
                  HumanPlayer.new(color: :black)]).play_chess
  end

  def human_vs_computer
    Game.new(
        players: [HumanPlayer.new(color: :white),
                  ComputerPlayer.new(color: :black)]).play_chess
  end

  def computer_vs_computer
    Game.new(
        players: [ComputerPlayer.new(color: :white),
                  ComputerPlayer.new(color: :black)]).play_chess
  end
end

Chess.new.main_menu
