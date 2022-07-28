class Square
  attr_reader :file, :rank, :background_color
  attr_accessor :piece

  def initialize(file:, rank:, piece: nil)
    @file             = file
    @rank             = rank
    @piece            = piece
    @background_color = choose_color(file, rank)
  end

  def to_s
    file_map =
      {1 => 'a', 2 => 'b', 3 => 'c', 4 => 'd',
       5 => 'e', 6 => 'f', 7 => 'g', 8 => 'h'}
    file_map[file].concat(rank.to_s)
  end

  private

  def choose_color(file, rank)
    same_parity?(file, rank) ? 'dark' : 'light'
  end

  def same_parity?(file, rank)
    (file % 2) == (rank % 2)
  end
end
