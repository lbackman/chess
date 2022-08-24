# frozen_string_literal: true

# lib/save.rb

require 'yaml'

# saves games
module Save
  SAVEFILE = 'savefile.yaml'

  def read_saved_games
    YAML.safe_load(File.read(SAVEFILE),
                   aliases: true,
                   permitted_classes: [Symbol,
                                       Game,
                                       Board,
                                       HumanPlayer,
                                       ComputerPlayer,
                                       Square,
                                       Pieces::Piece,
                                       Pieces::Pawn,
                                       Pieces::Knight,
                                       Pieces::Bishop,
                                       Pieces::Rook,
                                       Pieces::Queen,
                                       Pieces::King])
  rescue Errno::ENOENT
    {}
  end

  def save_game
    saved = read_saved_games
    @save_message = 'Enter save name: '
    display
    @save_message = ''
    name = gets.chomp
    saved[name] = self
    File.open(SAVEFILE, 'w') { |file| file.puts YAML.dump(saved) }
    @save_message = "Saved under '#{name}'       \033[30D"
    display
    @save_message = "\033[K"
  end
end
