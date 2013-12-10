require './ms_tile'
require './ms_board'
require './ms_timer'
require 'yaml'
require 'json'

require 'debugger'

class Minesweeper
  attr_accessor :board
  attr_reader :num_of_mines
  
  def initialize(size, num_of_mines)
    @board = Board.new(size, num_of_mines)
    @num_of_mines = num_of_mines
    start_timer
  end
  
  def start_timer
    @timer = Timer.new
  end
  
  def stop_timer
    @timer.stop
  end
  
  def show_game_time
    @timer.show_elapsed_time
  end
  
  def self.load_game(save_file)
    game_yaml = File.read(save_file)
    YAML::load(game_yaml)
  end
  
  def play
    until won?
      board.show
      command, coordinates = prompt_user
      
      case command
      when "r"
        break unless board.reveal(coordinates)
      when "f"
        board.flag(coordinates) unless board.tiles[input_coord[0]][input_coord[1]].revealed
      when "s"
        save_game
      end
    end
    
    board.show_end
    @timer.stop
    show_game_time
    if won?
      puts "You won!"
      record_game_time
    else
      puts "You lost!"
    end
    
    
  end
  
  def prompt_user
    puts "Type 'r [coordinates]' to reveal."
    puts "Type 'f [coordinates]' to flag."
    user_input = gets.chomp.gsub(' ', '')
    [user_input[0], user_input[1..-1].split(",").map(&:to_i)]
  end
  
  def won?
    unrevealed_tiles = 0
    @board.tiles.each do |tile_row|
      tile_row.each do |tile|
        unrevealed_tiles += 1 unless tile.revealed
      end
    end
    
    unrevealed_tiles == num_of_mines
  end
  
  def save_game
    File.open("saved_game.txt", "w") do |file|
      file.puts self.to_yaml
    end
  end
  
  def record_game_time
    leaderboard = load_leaderboard
    puts leaderboard.class
    game_time = @timer.elapsed_time
    
    if game_time < leaderboard.last
      leaderboard.each_with_index do |completion_time, idx|
        if game_time < completion_time
          leaderboard.insert(idx, game_time)
          leaderboard.pop
          game_time = 999999
        end
      end
    end
    
    puts "Top 10 Completion Times:"
    leaderboard.each do |score|
      puts "#{score} seconds"
    end
    
    save_leaderboard(leaderboard)
  end
  
  def load_leaderboard
    JSON.parse(File.read("leaderboard.json"))
  end
  
  def save_leaderboard(leaderboard)
    File.open("leaderboard.json", "w") do |file|
      file.puts leaderboard.to_json
    end
  end
end

# ms = Minesweeper.new(9, 1)
# ms.play
# loaded = Minesweeper.load_game("saved_game.txt")
# loaded.play