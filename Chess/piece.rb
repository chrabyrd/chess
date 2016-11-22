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

  def to_s
    #duck typing
  end

  def moves
    #duck typing
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

  def moves(board)
    possible_moves = []

    if self.color == :white
      right_diag = [self.location[0] + 1, self.location[1] + 1]
      left_diag = [self.location[0] + 1, self.location[1] - 1]
      advance_move = [self.location[0] + 1, self.location[1]]
      advance_two = [self.location[0] + 2, self.location[1]]

      possible_moves << right_diag if board[right_diag].color == :black &&
                                      board.in_bounds?(right_diag)
      possible_moves << left_diag if board[left_diag].color == :black &&
                                     board.in_bounds?(left_diag)
      possible_moves << advance_move unless board[advance_move].color ||
                                     !board.in_bounds?(advance_move)
      if possible_moves.include?(advance_move) && self.location[0] == 1
        possible_moves << advance_two unless board[advance_move].color ||
                                     !board.in_bounds?(advance_move)
      end
    elsif self.color == :black
      right_diag = [self.location[0] - 1, self.location[1] + 1]
      left_diag = [self.location[0] - 1, self.location[1] - 1]
      advance_move = [self.location[0] - 1, self.location[1]]
      advance_two = [self.location[0] - 2, self.location[1]]

      possible_moves << right_diag if board[right_diag].color == :white &&
                                      board.in_bounds?(right_diag)
      possible_moves << left_diag if board[left_diag].color == :white &&
                                     board.in_bounds?(left_diag)
      possible_moves << advance_move unless board[advance_move].color ||
                                     !board.in_bounds?(advance_move)
      if possible_moves.include?(advance_move) && self.location[0] == 6
        possible_moves << advance_two unless board[advance_move].color ||
                                     !board.in_bounds?(advance_move)
      end
    end
    return possible_moves
  end

  def move_dirs
    #duck typing
  end

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
