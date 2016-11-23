require 'singleton'
require 'byebug'

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
  def moves(board)
    possible_moves = []
    move_dirs.each do |direction|
      current_pos = self.location.dup
      while board.in_bounds?(current_pos)
        possible_moves << current_pos unless current_pos == self.location
        current_pos = [ current_pos[0] + direction[0],
                        current_pos[1] + direction[1] ]
        next unless board.in_bounds?(current_pos)
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
  def moves(board)
    possible_moves = []
    move_dirs.each do |direction|
      possible_move = [ self.location[0] + direction[0],
                        self.location[1] + direction[1] ]
      if board.in_bounds?(possible_move) && self.color != board[possible_move].color
        possible_moves << possible_move
      end
    end
    possible_moves
  end
end

class Piece
  attr_accessor :location
  attr_reader :color

  def initialize(color, location)
    @color = color
    @location = location
  end

  def update_location(location)
    @location = location
  end

  def dup
    self.class.new(self.color, self.location)
  end

  def to_s
    #duck typing
  end

  def moves(board)
    #duck typing
  end

  def valid_moves(board)
    moves(board).reject do |move|
      duped_board = board.deep_dup(board.grid)
      duped_board.move_piece(self.location, move)
      duped_board.in_check?(self.color)
    end
  end

end

class King < Piece
  include SteppingPiece

  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1], [0, 1], [1, 0], [-1, 0], [0, -1]]
  end

  def to_s
    @color == :black ? UNICODE_HASH[:black_king] : UNICODE_HASH[:white_king]
  end
end

class Queen < Piece
  include SlidingPiece

  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1], [0, 1], [1, 0], [-1, 0], [0, -1]]
  end

  def to_s
    @color == :black ? UNICODE_HASH[:black_queen] : UNICODE_HASH[:white_queen]
  end
end

class Bishop < Piece
  include SlidingPiece

  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def to_s
    @color == :black ? UNICODE_HASH[:black_bishop] : UNICODE_HASH[:white_bishop]
  end
end

class Knight < Piece
  include SteppingPiece

  def move_dirs
    [[2, 1], [2, -1], [-1, 2], [-1, -2], [1, 2], [1, -2], [-2, 1], [-2, -1]]
  end

  def to_s
    @color == :black ? UNICODE_HASH[:black_knight] : UNICODE_HASH[:white_knight]
  end
end

class Rook < Piece
  include SlidingPiece

  def move_dirs
    [[0, 1], [1, 0], [-1, 0], [0, -1]]
  end


  def to_s
    @color == :black ? UNICODE_HASH[:black_rook] : UNICODE_HASH[:white_rook]
  end
end

class Pawn < Piece

  def pawn_move(diff, board)
    possible_location = [self.location[0] + diff[0], self.location[1] + diff[1]]

    if diff[1] != 0 #diagonals
      col = (self.color == :white ? :black : :white)
    else #forward moves
      col = nil
    end
    if board.in_bounds?(possible_location) && board[possible_location].color == col
      possible_location
    end
  end

  def moves(board)
    possible_moves = []
    orig_pawn_row = move_dirs[0][0] == 1 ? 1 : 6
    advance_move = [self.location[0] + move_dirs[2][0], self.location[1]]

    move_dirs.each_with_index do |diff, idx|
      if idx == 3
        next unless self.location[0] == orig_pawn_row && possible_moves.include?(advance_move)
      end
      possible_move = pawn_move(diff, board)
      possible_moves << possible_move if possible_move
    end

    possible_moves
  end

  def move_dirs
    if self.color == :white
      [[1, 1], [1, -1], [1, 0], [2, 0]]
    elsif self.color == :black
      [[-1, 1], [-1, -1], [-1, 0], [-2, 0]]
    end
  end

  def to_s
    @color == :black ? UNICODE_HASH[:black_pawn] : UNICODE_HASH[:white_pawn]
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
  end

  def dup
    self
  end

  def to_s
    "-"
  end
end
