class Game < Gosu::Window
  
  def self.play!
    new.show
  end
  
  def initialize
    super(WINDOW_WIDTH,WINDOW_HEIGHT)
    @world = World.new(WORLD_WIDTH,WORLD_HEIGHT)
  end
  
  def update
  end
  
  def draw
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR,0,0) do
      @world.draw
    end
  end
    
  
end