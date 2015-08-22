class Monster
  attr_reader :cell, :health, :resources
  
  def initialize(cell,spec,resources)
    @cell = cell
    @health = spec.health
    @resources = resources
  end
    
end