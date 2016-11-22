require 'singleton'

UNICODE_HASH = {
  white_king: "\u2654".encode('utf-8'),
  white_queen: "\u2655".encode('utf-8'),
  white_rook: "\u2656".encode('utf-8'),
  white_bishop: "\u2657".encode('utf-8'),
  white_knight: "\u2658".encode('utf-8'),
  white_pawn: "\u2659".encode('utf-8'),
  black_king: "\u265a".encode('utf-8'),
  black_queen: "\u265b".encode('utf-8'),
  black_rook: "\u265c".encode('utf-8'),
  black_bishop: "\u265d".encode('utf-8'),
  black_knight: "\u265e".encode('utf-8'),
  black_pawn: "\u265f".encode('utf-8')
}

#rook [[0,1],[1,0],[-1,0],[0,-1]]

module SlidingPiece
  def moves(directions_array, board)
    possible_moves = []
    directions_array.each do |direction|
      current_pos = self.location.dup
      while board.in_bounds?(current_pos)
        possible_moves << current_pos unless current_pos == self.location
        current_pos = [ current_pos[0] + direction[0],
                        current_pos[1] + direction[1] ]
        current_color = board[current_pos].color
        unless current_color.nil?
          unless self.color == current_color
            possible_moves << current_pos
          end
          break
        end
      end
    end
    possible_moves
  end
end

module SteppingPiece

end

class Piece
  attr_accessor :location
  attr_reader :color
  def initialize(color, location)
    @color = color
    @location = location
  end

  def to_s
    #duck typing
  end

  def moves
    #duck typing
  end

end

class King < Piece
  def to_s
    @color == :black ? UNICODE_HASH[:black_king] : UNICODE_HASH[:white_king]
  end
end

class Queen < Piece
  include SlidingPiece

  def to_s
    @color == :black ? UNICODE_HASH[:black_queen] : UNICODE_HASH[:white_queen]
  end
end

class Bishop < Piece
  include SlidingPiece

  def to_s
    @color == :black ? UNICODE_HASH[:black_bishop] : UNICODE_HASH[:white_bishop]
  end
end

class Knight < Piece
  def to_s
    @color == :black ? UNICODE_HASH[:black_knight] : UNICODE_HASH[:white_knight]
  end
end

class Rook < Piece
  include SlidingPiece



  def to_s
    @color == :black ? UNICODE_HASH[:black_rook] : UNICODE_HASH[:white_rook]
  end
end

class Pawn < Piece
  def to_s
    @color == :black ? UNICODE_HASH[:black_pawn] : UNICODE_HASH[:white_pawn]
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
  end

  def to_s
    "-"
  end
end
