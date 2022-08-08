class Square
  attr_reader :file, :rank, :background_color
  attr_accessor :piece, :marked

  def initialize(file:, rank:, piece: nil)
    @file             = file
    @rank             = rank
    @piece            = piece
    @background_color = choose_color
    @marked           = false
  end

  def to_s
    file_map =
      {1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd',
       5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h'}
    file_map[file].concat(rank.to_s)
  end

  def piece_symbol
    piece ? piece.symbol : ' '
  end

  def piece_name
    piece&.name
  end

  def piece_color
    piece&.color
  end

  def upper_lower_third
    "\u001b[48;5;#{choose_color}m     \u001b[0m"
  end

  def middle_third
    "\u001b[48;5;#{choose_color}m  #{piece_symbol}  \u001b[0m"
  end

  private

  def choose_color
    return '48' if marked

    same_parity? ? '223' : '255'
  end

  def same_parity?
    (file % 2) == (rank % 2)
  end
end
