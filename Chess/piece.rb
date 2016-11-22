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


class Piece
  def initialize(color)
    @color = color
  end

  def to_s

  end

end

class King < Piece
  def to_s
    @color == :black ? UNICODE_HASH[:black_king] : UNICODE_HASH[:white_king]
  end
end

class Queen < Piece
  def to_s
    @color == :black ? UNICODE_HASH[:black_queen] : UNICODE_HASH[:white_queen]
  end
end

class Bishop < Piece
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
  def to_s
    "-"
  end
end
