class Settlement
  attr_reader :cell, :population, :resources
  def initialize(cell,population,resources)
    @cell = cell
    @population = population
    @resources = resources
    
    self.tribe.settlements << self
  end
  
  def tribe
    @population.tribe
  end
end