module Pieces
  DIAGONALS   = [[1, 1], [-1, 1]]
  LINES       = [[1, 0], [0, 1]]
  UP_DOWN     = [[0, 1]]
  KNIGHTMOVES = [[1, 2], [2, 1], [-1, 2], [-2, 1]]

  def self.config(color1, color2)
    Hash.new(piece: nil).merge(
      { file: 1, rank: 1 } => { piece: Pieces::Rook.new(color1) },
      { file: 2, rank: 1 } => { piece: Pieces::Knight.new(color1) },
      { file: 3, rank: 1 } => { piece: Pieces::Bishop.new(color1) },
      { file: 4, rank: 1 } => { piece: Pieces::Queen.new(color1) },
      { file: 5, rank: 1 } => { piece: Pieces::King.new(color1) },
      { file: 6, rank: 1 } => { piece: Pieces::Bishop.new(color1) },
      { file: 7, rank: 1 } => { piece: Pieces::Knight.new(color1) },
      { file: 8, rank: 1 } => { piece: Pieces::Rook.new(color1) },
      { file: 1, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 2, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 3, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 4, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 5, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 6, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 7, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 8, rank: 2 } => { piece: Pieces::Pawn.new(color1) },
      { file: 1, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 2, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 3, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 4, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 5, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 6, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 7, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 8, rank: 7 } => { piece: Pieces::Pawn.new(color2) },
      { file: 1, rank: 8 } => { piece: Pieces::Rook.new(color2) },
      { file: 2, rank: 8 } => { piece: Pieces::Knight.new(color2) },
      { file: 3, rank: 8 } => { piece: Pieces::Bishop.new(color2) },
      { file: 4, rank: 8 } => { piece: Pieces::Queen.new(color2) },
      { file: 5, rank: 8 } => { piece: Pieces::King.new(color2) },
      { file: 6, rank: 8 } => { piece: Pieces::Bishop.new(color2) },
      { file: 7, rank: 8 } => { piece: Pieces::Knight.new(color2) },
      { file: 8, rank: 8 } => { piece: Pieces::Rook.new(color2) } )
  end

  class Piece
    attr_reader :color
    attr_accessor :times_moved, :available_moves
    def initialize(color)
      @color = color
      @times_moved = 0
      @available_moves = []
    end

    def name
      ''
    end

    def direction
      [1, -1]
    end

    def movements
      [LINES, DIAGONALS].inject(:+)
    end

    def vectors
      vectors = []
      direction.each do |d|
        movements.each do |m|
          vectors << m.map { |el| el * d }
        end
      end
      vectors
    end

    def range
      7
    end

    def symbol
      ' '
    end

    def enemy?(other_piece)
      color != other_piece.color
    end

    def to_s
      symbol
    end
  end

  class Pawn < Piece
    def name
      'pawn'
    end

    def direction
      { white: 1, black: -1 }[color]
    end

    def symbol
      { white: "\u2659", black: "\u265f" }[color]
    end

    def movements
      { move: UP_DOWN, attack: DIAGONALS }
    end

    def vectors
      vectors = {}
      movements.each do |key, val|
        vectors[key] = val.map { |arr| arr.map { |el| el * direction } }
      end
      vectors
    end

    def range
      times_moved.zero? ? 2 : 1
    end
  end

  class Knight < Piece
    def name
      'knight'
    end

    def symbol
      { white: "\u2658", black: "\u265e" }[color]
    end

    def movements
      KNIGHTMOVES
    end

    def range
      1
    end
  end

  class Bishop < Piece
    def name
      'bishop'
    end

    def symbol
      { white: "\u2657", black: "\u265d" }[color]
    end

    def movements
      DIAGONALS
    end
  end

  class Rook < Piece
    def name
      'rook'
    end

    def symbol
      { white: "\u2656", black: "\u265c" }[color]
    end

    def movements
      LINES
    end
  end

  class Queen < Piece
    def name
      'queen'
    end

    def symbol
      { white: "\u2655", black: "\u265b" }[color]
    end
  end

  class King < Piece
    def name
      'king'
    end

    def symbol
      { white: "\u2654", black: "\u265a" }[color]
    end

    def range
      1
    end
  end
end
