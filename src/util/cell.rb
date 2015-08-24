class Cell
  attr_reader :x, :y
  attr_accessor :terrain, :settlement
  
  def initialize(x,y,grid)
    @x, @y, @grid = x, y, grid
    @worked = false
  end
  
  def worked?
    !!@worked
  end
  
  def reset_work!
    @worked = false
  end
  
  def work!
    @worked = true
  end
  
  def draw
    @terrain.draw(xpos,ypos)
    @settlement.image.draw(xpos,ypos,1) if settlement
  end
  
  def xpos
    x*TILE_WIDTH
  end
  
  def ypos
    y*TILE_HEIGHT
  end
  
  def north; @grid[x,y-1] end
  def south; @grid[x,y+1] end
  def east;  @grid[x+1,y] end
  def west;  @grid[x-1,y] end
  
  def entered_by_monster
    if @settlement
      Game.monster_entered_settlement(@settlement)
    else
      Game.tick!
    end
  end
  
  def valence(radius)
    @grid.valence(x,y,radius)
  end
  
  def around(radius)
    @grid.around(x,y,radius)
  end
  
  class OutOfBounds < Cell
    def terrain
      Terrain::OutOfBounds.new
    end
  end
  
end