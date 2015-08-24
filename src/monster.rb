class Monster
  attr_reader :cell, :health, :name
  attr_accessor :food, :gold
  
  def initialize(cell,spec)
    @cell = cell
    @health = spec.health
    @gold = spec.gold
    @food = spec.food
    @name = spec.name
  end
    
  def image
    ImageManager.image(name)
  end  
    
  def draw
    image.draw(cell.xpos,cell.ypos,2)
  end
  
  def move(direction)
    target = cell.send(direction)
    if target.terrain.traversable?
      @cell = target
      @cell.entered_by_monster
    end
  end
  
  def strength
    @health
  end
  
  def take_damage(amount)
    @health -= amount
    amount
  end
  
  def alive?
    @health > 0
  end
  
  def dead?
    !alive?
  end
  
  def tick!
    if Calendar.time_of_day == :night
      if @food > 0
        @food -= 1
      else
        take_damage(1)
        if dead?
          Game.player_lost
        end
      end
    end
  end
  
end