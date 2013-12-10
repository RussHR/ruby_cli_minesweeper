class Tile
  attr_accessor :value, :mine, :board, :revealed, :flagged
  
  def initialize(board)
    @value = "*"
    @board = board
    @mine = false
    @revealed = false
    @flagged = false
  end
  
  def is_mine?
    @mine
  end
  
end