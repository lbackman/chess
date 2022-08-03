require 'colorize'
module Pieces
  def self.config(color1, color2)
    Hash.new(piece: nil).merge(
      { file: 1, rank: 1 } => { piece: [Pieces::Rook,   color1] },
      { file: 2, rank: 1 } => { piece: [Pieces::Knight, color1] },
      { file: 3, rank: 1 } => { piece: [Pieces::Bishop, color1] },
      { file: 4, rank: 1 } => { piece: [Pieces::Queen,  color1] },
      { file: 5, rank: 1 } => { piece: [Pieces::King,   color1] },
      { file: 6, rank: 1 } => { piece: [Pieces::Bishop, color1] },
      { file: 7, rank: 1 } => { piece: [Pieces::Knight, color1] },
      { file: 8, rank: 1 } => { piece: [Pieces::Rook,   color1] },
      { file: 1, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 2, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 3, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 4, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 5, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 6, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 7, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 8, rank: 2 } => { piece: [Pieces::Pawn,   color1] },
      { file: 1, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 2, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 3, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 4, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 5, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 6, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 7, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 8, rank: 7 } => { piece: [Pieces::Pawn,   color2] },
      { file: 1, rank: 8 } => { piece: [Pieces::Rook,   color2] },
      { file: 2, rank: 8 } => { piece: [Pieces::Knight, color2] },
      { file: 3, rank: 8 } => { piece: [Pieces::Bishop, color2] },
      { file: 4, rank: 8 } => { piece: [Pieces::Queen,  color2] },
      { file: 5, rank: 8 } => { piece: [Pieces::King,   color2] },
      { file: 6, rank: 8 } => { piece: [Pieces::Bishop, color2] },
      { file: 7, rank: 8 } => { piece: [Pieces::Knight, color2] },
      { file: 8, rank: 8 } => { piece: [Pieces::Rook,   color2] } )
  end

  class Piece
    attr_reader :color
    def initialize(color)
      @color = color

      # post_initialize
    end

    def name
      ''
    end

    def direction
      'all'
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
    # attr_reader :first_move#, :range
    # def post_initialize
    #   @moved = false
    #   @range = determine_range
    # end

    # def determine_range
    #   first_move ? 1 : 2
    # end

    def name
      'pawn'
    end

    def direction
      { 'white' => 'up', 'black' => 'down' }[color]
    end

    def symbol
      { 'white' => "\u2659", 'black' => "\u265f" }[color]
      # "\u265f".send(color.to_sym)
    end
  end

  class Knight < Piece
    def name
      'knight'
    end

    def symbol
      { 'white' => "\u2658", 'black' => "\u265e" }[color]
      # "\u265e".send(color.to_sym)
    end
  end

  class Bishop < Piece
    def name
      'bishop'
    end

    def symbol
      { 'white' => "\u2657", 'black' => "\u265d" }[color]
      # "\u265d".send(color.to_sym)
    end
  end

  class Rook < Piece
    def name
      'rook'
    end

    def symbol
      { 'white' => "\u2656", 'black' => "\u265c" }[color]
      # "\u265c".send(color.to_sym)
    end
  end

  class Queen < Piece
    def name
      'queen'
    end

    def symbol
      { 'white' => "\u2655", 'black' => "\u265b" }[color]
      # "\u265b".send(color.to_sym)
    end
  end

  class King < Piece
    def name
      'king'
    end

    def symbol
      { 'white' => "\u2654", 'black' => "\u265a" }[color]
      # "\u265a".send(color.to_sym)
    end
  end
end
