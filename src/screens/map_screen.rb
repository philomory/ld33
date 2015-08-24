class MapScreen < Screen
  
  def initialize(world,monster)
    @world, @monster = world, monster
  end
  
  def update
  end
  
  def draw
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR,0,0) do
      @world.draw
      @monster.draw
    end
  end
  
  def button_down(button_id)
    case button_id
    when Gosu::KbDown   then @monster.move(:south)
    when Gosu::KbUp     then @monster.move(:north)
    when Gosu::KbLeft   then @monster.move(:west)
    when Gosu::KbRight  then @monster.move(:east)
    when Gosu::KbSpace  then Game.tick!
    end
  end
end