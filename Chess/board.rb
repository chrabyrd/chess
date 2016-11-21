require_relative 'piece.rb'
class Board
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

  def move_piece(start_pos,end_pos)
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
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
    self[[0, 3]], self[[7, 3]] = King.new(:white), King.new(:black)
  end

  def create_queens
    self[[0, 4]], self[[7, 4]] = Queen.new(:white), Queen.new(:black)
  end

  def create_bishops
    self[[0, 5]], self[[0, 2]] = Bishop.new(:white), Bishop.new(:white)
    self[[7, 5]], self[[7, 2]] = Bishop.new(:black), Bishop.new(:black)
  end

  def create_knights
    self[[0, 1]], self[[0, 6]] = Knight.new(:white), Knight.new(:white)
    self[[7, 1]], self[[7, 6]] = Knight.new(:black), Knight.new(:black)
  end

  def create_rooks
    self[[0, 0]], self[[0, 7]] = Rook.new(:white), Rook.new(:white)
    self[[7, 0]], self[[7, 7]] = Rook.new(:black), Rook.new(:black)
  end

  def create_null_pieces
    2.upto(5) do |row|
      @grid[row].map! do
        NullPiece.new(:nil)
      end
    end
  end

  def create_pawns
    @grid[1].map! do
      Pawn.new(:white)
    end

    @grid[6].map! do
      Pawn.new(:black)
    end
  end
end

b = Board.new

b.move_piece([0,0], [0,1])

p b
