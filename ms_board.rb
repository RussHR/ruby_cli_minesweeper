class Board
  attr_accessor :tiles, :size
  
  def initialize(size, num_of_mines)
    @size = size
    create_board
    set_mines(num_of_mines)
  end
  
  def [](position)
    tiles[position[0]][position[1]]
  end
  
  def create_board
    @tiles = Array.new(size) { Array.new(size) { Tile.new(self) } }
  end
  
  def set_mines(number) 
    number.times do
      x = rand(9)
      y = rand(9)
      redo if tiles[x][y].is_mine?
      tiles[x][y].mine = true
      
      p "mine: #{[x,y]}"
    end
  end
  
  def show
    tiles.each do |tile_row|
      p tile_row.map {|tile| tile.value.to_s}
    end
  end
  
  def show_end
    tiles.each_with_index do |tile_row, x|
      tile_row.each_index do |y|
        @tiles[x][y].value = "M" if tiles[x][y].is_mine?
      end
    end
    
    show
  end
  
  def neighbors(pos)
    neighbor_positions = []
    position_adders = [ [-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1] ]
    position_adders.each do |position_adder|
      x = position_adder[0]+pos[0]
      y = position_adder[1]+pos[1]
      neighbor_positions << [x, y] if [x,y].all? {|coor| coor >= 0 && coor < size} 
    end
    
    neighbor_positions
  end
  
  def reveal(pos)
    tile = self[pos]
    return false if tile.is_mine?
    reveal_surrounding_tiles(pos) unless tile.value == "_"
    
    true
  end

  def reveal_surrounding_tiles(pos)
    x, y = pos
    neighbors_pos = neighbors([x,y])
    num_of_mines = number_of_mines(neighbors_pos)
    self[pos].revealed = true
    
    if num_of_mines == 0
      self[pos].value = "_"
      neighbors_pos.each do |neighbor|
        neigh_x = neighbor[0]
        neigh_y = neighbor[1]
        reveal_surrounding_tiles(neighbor) unless (tiles[neigh_x][neigh_y].revealed || tiles[neigh_x][neigh_y].flagged)
      end
    else
       tiles[x][y].value = num_of_mines
    end
  end
  
  def flag(pos)
    self[pos].flagged ? self[pos].flagged = false : self[pos].flagged = true 
  end
  
  def number_of_mines(neighor_tile_positions)
    mines = 0
    neighor_tile_positions.each do |tile_position|
      mines += 1 if self[tile_position].is_mine?
    end
    
    mines
  end
  
end