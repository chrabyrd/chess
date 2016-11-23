require_relative 'piece.rb'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(grid = default_board)
    @grid = grid
    create_pieces if @grid[0][0].nil?
  end

  def default_board
    Array.new(8) { Array.new(8) }
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, value)
    @grid[pos[0]][pos[1]] = value
  end

  def move_piece(start_pos, end_pos)
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    self[start_pos].update_location(start_pos)
    self[end_pos].update_location(end_pos)
  end

  def in_bounds?(pos)
    pos.all? { |num| num.between?(0, 7) }
  end

  def in_check?(color)
    king_pos = find_king(color)
    opposite_pieces = find_all_pieces(color == :white ? :black : :white)
    opposite_pieces.any? { |piece| piece.moves(self).include?(king_pos) }
  end

  def checkmate?(color)
    in_check?(color) && any_moves?(color)
  end

  def deep_dup(array)
    grid = deep_dup_helper(array)
    Board.new(grid)
  end

  private

  def any_moves?(color)
    find_all_pieces(color).any? { |piece| piece.moves(@board).!empty? }
  end

  def deep_dup_helper(array)
    array.map { |el| el.is_a?(Array) ? deep_dup_helper(el) : el.dup }
  end

  def find_king(color)
    @grid.each do |row|
      row.each do |square|
        return square.location if square.is_a?(King) &&
        square.color == color
      end
    end
    nil
  end

  def find_all_pieces(color)
    pieces = []
    @grid.each do |row|
      row.each do |square|
        pieces << square if square.color == color
      end
    end
    pieces
  end

  def create_pieces
    create_kings
    create_queens
    create_bishops
    create_knights
    create_rooks
    create_pawns
    create_null_pieces
  end

  def create_kings
    self[[0, 3]], self[[7, 3]] = King.new(:white,[0, 3]), King.new(:black, [7, 3])
  end

  def create_queens
    self[[0, 4]], self[[7, 4]] = Queen.new(:white, [0, 4]), Queen.new(:black, [7, 4])
  end

  def create_bishops
    self[[0, 5]], self[[0, 2]] = Bishop.new(:white, [0, 5]), Bishop.new(:white, [0, 2])
    self[[7, 5]], self[[7, 2]] = Bishop.new(:black, [7, 5]), Bishop.new(:black, [7, 2])
  end

  def create_knights
    self[[0, 1]], self[[0, 6]] = Knight.new(:white, [0, 1]), Knight.new(:white, [0, 6])
    self[[7, 1]], self[[7, 6]] = Knight.new(:black, [7, 1]), Knight.new(:black, [7, 6])
  end

  def create_rooks
    self[[0, 0]], self[[0, 7]] = Rook.new(:white, [0, 0]), Rook.new(:white, [0, 7])
    self[[7, 0]], self[[7, 7]] = Rook.new(:black, [7, 0]), Rook.new(:black, [7, 7])
  end

  def create_null_pieces
    single_null_piece = NullPiece.instance
    2.upto(5) do |row|
      @grid[row].map! do
        single_null_piece
      end
    end
  end

  def create_pawns
    @grid[1].map!.with_index do |_, idx|
      Pawn.new(:white, [1, idx])
    end

    @grid[6].map!.with_index do |_, idx|
      Pawn.new(:black, [6, idx])
    end
  end
end

b = Board.new


# b.move_piece([6, 3], [2, 0])
# b.move_piece([7, 7], [6, 2])
# b.move_piece([0, 0], [5, 3])
# b.move_piece([0,2],[3,0])
# b.move_piece([1,2],[5,0])
#
# p b[[6, 2]].valid_moves(b)
