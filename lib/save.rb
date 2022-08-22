require 'yaml'

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
                                       Pieces::King] )
  rescue Errno::ENOENT
    {}
  end

  def save_game
    saved = read_saved_games
    print 'Enter save name: '
    name = gets.chomp
    saved[name] = self
    File.open(SAVEFILE, 'w') do |file|
      file.puts YAML.dump(saved)
    end
    puts "Saved under '#{name}'"
    $stdin.getch
  end

  # def save_game
  #   Dir.mkdir 'saves' unless Dir.exist?('saves')
  #   filename = "#{create_filename}.yaml"
  #   File.open("saves/#{filename}", 'w') { |file| file.write save_to_yaml }
  #   display_file_location(filename)
  # rescue SystemCallError => e
  #   puts "Error while writing to file #{filename}."
  #   puts e
  # end

  # def save_to_yaml
  #   YAML.dump(self)
  # end

  # def load_game
  #   puts 'Which file to open?'
  #   game_file = gets.chomp
  #   game_file = File.open("saves/#{game_file}.yaml", 'r') { |file| file.read }
  #   YAML::load(game_file)
  #   play_chess
  #  end

  # private

  # def create_filename
  #   puts "Name your save file:  "
  #   gets.chomp
  # end

  # def display_file_location(filename)
  #   puts "The current game has been saved in saves/#{filename}."
  # end
end
  