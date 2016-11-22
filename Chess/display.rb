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
    render
    @cursor.get_input
    render
  end
end

b = Board.new

d = Display.new(b)

d.rendering
