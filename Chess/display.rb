require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render
    print "   "
    (0..7).each { |n| print "#{n} " }
    @board.grid.each_with_index do |row, row_idx|
      print "\n #{row_idx} "
      row.each_with_index do |piece , col_idx|
        if [row_idx, col_idx] == @cursor.cursor_pos
          print "#{piece.to_s.colorize(:background => :red)} "
        else
          print "#{piece.to_s} "
        end
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
