class Timer
  attr_reader :elapsed_time
  
  def initialize
    @start_time = Time.now
  end
  
  def stop
    @stop_time = Time.now
  end
  
  def elapsed_time
    @elapsed_time = @stop_time - @start_time
  end
  
  def show_elapsed_time
    puts "Game time elapsed: #{elapsed_time} seconds"
  end
end