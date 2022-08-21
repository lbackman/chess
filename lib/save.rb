require 'yaml'

module Save
  def save_game
    Dir.mkdir 'saves' unless Dir.exist?('saves')
    filename = "#{create_filename}.yaml"
    File.open("saves/#{filename}", 'w') { |file| file.write save_to_yaml }
    display_file_location(filename)
  rescue SystemCallError => e
    puts "Error while writing to file #{filename}."
    puts e
  end

  def save_to_yaml
    YAML.dump(self)
  end

  def load_game
    puts 'Which file to open?'
    game_file = gets.chomp
    game_file = File.open("saves/#{game_file}.yaml", 'r') { |file| file.read }
    YAML::load(game_file)
    play_chess
   end

  private

  def create_filename
    puts "Name your save file:  "
    gets.chomp
  end

  def display_file_location(filename)
    puts "The current game has been saved in saves/#{filename}."
  end
end
  