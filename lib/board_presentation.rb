# frozen_string_literal: true

# lib/board_presentation.rb

# renders the board
module BoardPresentation
  def print_board
    puts "\033[31A"
    puts legend
    puts 8.downto(1).map { |i| print_rank(i) }.join("\n")
    puts print_files
  end

  private

  def legend
    "      MOVE: \u2190\u2191\u2192\u2193, SAVE: 'S', QUIT: 'Q'"
  end

  def print_upper_lower_rank(rank)
    1.upto(8).map { |i| board[[i, rank]].upper_lower_third }.join
  end

  def print_middle_rank(rank)
    1.upto(8).map { |i| board[[i, rank]].middle_third }.join
  end

  def print_rank(rank)
    " #{print_upper_lower_rank(rank)} \n" \
      "#{rank}#{print_middle_rank(rank)}\n" \
      " #{print_upper_lower_rank(rank)} "
  end

  def print_files
    '   a    b    c    d    e    f    g    h    '
  end
end
