# frozen_string_literal: true

# lib/pieces.rb

# handles pieces, their moves, and set-up
module Pieces
  DIAGONALS   = [[1, 1], [-1, 1]].freeze
  LINES       = [[1, 0], [0, 1]].freeze
  UP_DOWN     = [[0, 1]].freeze
  KNIGHTMOVES = [[1, 2], [2, 1], [-1, 2], [-2, 1]].freeze

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
      { file: 8, rank: 8 } => { piece: Pieces::Rook.new(color2) }
    )
  end

  # base class
  class Piece
    attr_reader :color
    attr_accessor :times_moved, :available_moves

    def initialize(color)
      @color = color
      @times_moved = 0
      @available_moves = []

      post_initialize
    end

    def post_initialize; end

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

    def ep_vulnerable?(*)
      false
    end

    def to_s
      symbol
    end
  end

  # pawn class
  class Pawn < Piece
    attr_accessor :ep_counter

    def post_initialize
      @ep_counter = 0
    end

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
      { move: UP_DOWN, capture: DIAGONALS }
    end

    def vectors
      vectors = {}
      movements.each do |key, val|
        vectors[key] = val.map { |arr| arr.map { |el| el * direction } }
      end
      vectors
    end

    def ep_vulnerable?(rank)
      times_moved == 1 && ep_counter == 1 && [4, 5].include?(rank)
    end

    def range
      times_moved.zero? ? 2 : 1
    end
  end

  # knight class
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

  # bishop class
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

  # rook class
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

  # queen class
  class Queen < Piece
    def name
      'queen'
    end

    def symbol
      { white: "\u2655", black: "\u265b" }[color]
    end
  end

  # king class
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
