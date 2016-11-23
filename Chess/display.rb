require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render
    cur_piece = @board[@cursor.cursor_pos] #some piece
    print "   "
    (0..7).each { |n| print "#{n} " }
    @board.grid.each_with_index do |row, idx|
      print "\n #{idx} "
      row.each do |piece|
        print piece == cur_piece ? "#{piece.to_s.colorize(:background => :red)} " : "#{piece.to_s} "
      end
    end
    print "\n"
  end

  def rendering
    loop do
      render
      @cursor.get_input
      system 'clear'
    end
  end
end



b = Board.new


b.move_piece([6, 2], [4, 2])
b.move_piece([6, 1], [4, 1])
b.move_piece([1, 3], [3, 3])
b.move_piece([0,4],[4,0])
# b.move_piece([6,0],[3,7])
# b.move_piece([7,0],[6,1])
b.move_piece([6,4],[5,4])
# b.move_piece([1,2],[5,0])
d = Display.new(b)
d.rendering

p b.in_check?(:black)

p b.checkmate?(:black)
