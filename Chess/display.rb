require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb'

class Display
  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end
end
