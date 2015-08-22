class Cell
  attr_reader :x, :y
  attr_accessor :terrain
  
  def initialize(x,y)
    @x, @y = x, y
  end
  
  
  def draw
    @terrain.image.draw(x*TILE_WIDTH,y*TILE_HEIGHT,0)
  end
end