require_relative 'piece.rb'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    create_pieces
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

  private

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




p b[[0, 1]].moves(b)

# p b
