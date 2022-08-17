require 'io/console'

module Input
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
end
