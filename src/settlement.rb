class Settlement
  RANK_NAMES = %w{camp village town city fort castle}
  MAX_FOOD_STORAGE = 300
  
  attr_reader :cell, :population, :resources, :rank, :name
  def initialize(cell,population,resources)
    @cell = cell
    @population = population
    @resources = resources
    
    @name = self.class.random_name
    
    @rank = 0
    
    self.tribe.settlements << self
    
    @workable_cells = @cell.around(3).select {|cell| cell.terrain.can_work?}
  end
  
  def tribe
    @population.tribe
  end
  
  def image
    ImageManager.image('settlement')
  end
  
  def rank_name
    RANK_NAMES[rank].capitalize
  end
  
  def tick!
    if alive?
      if Calendar.time_of_day == :day
        do_work
      else
        do_consume
        do_lifecycle
        do_bookkeep
      end
    else
      do_decay
    end
  end
  
  def alive?
    @population.size > 0
  end
  
  def dead?
    !alive?
  end
  
  def do_decay
    @resources.food = [(@resources.food * 0.8).to_i - 1, 0].max
    @resources.lumber = [(@resources.lumber * 0.95).to_i - 1, 0].max
    rand(100) < 10 ? @resources.gold = [@resources.gold - 1,0].max : @resources.gold
    rand(2).even?  ? @resources.iron = [@resources.iron - 1,0].max : @resources.iron
    if @resources.food.zero? && @resources.gold.zero?
      remove_settlement
    end
  end
  
  def remove_settlement
    Game.world.remove_settlement(self)
    @cell.settlement = nil
  end
  
  def do_bookkeep
    @resources.food = [@resources.food,MAX_FOOD_STORAGE].min
  end
  
  def do_work
    farmer_work
    hunter_work
    crafter_work
  end
  
  def farmer_work
    @population.farmers.times do
      target = @workable_cells.select {|cell| cell.terrain.is_a?(Terrain::Grassland) }.sample
      if target.nil?
        target = @workable_cells.sample
      end
      harvest = target.terrain.work_result(:farmers) || {}
      harvest.each_pair {|r,a| @resources[r] += a }
    end
  end
  
  def hunter_work
    @population.hunters.times do
      target = @workable_cells.select {|cell| cell.terrain.is_a?(Terrain::Forest) }.sample
      if target.nil?
        target = @workable_cells.sample
      end
      harvest = target.terrain.work_result(:hunters) || {}
      harvest.each_pair {|r,a| @resources[r] += a }
    end
  end
  
  def crafter_work
    @population.hunters.times do
      if [true,false].sample
        make_crafts
      else
        target = @workable_cells.select {|cell| cell.terrain.is_a?(Terrain::Forest) || cell.terrain.is_a?(Terrain::Mountain) }.sample
        if target.nil?
          target = @workable_cells.sample
        end
        harvest = target.terrain.work_result(:crafters) || {}
        harvest.each_pair {|r,a| @resources[r] += a }
      end
    end
  end
  
  def make_crafts
  end
  
  def do_consume
    if @resources[:food] >= @population.size
      @resources[:food] -= @population.size
    else
      starve!
      @resources[:food] = 0
    end
  end
  
  def starve!
    num_starved = @population.size - @resources[:food]
    num_starved.times { @population.kill_random_person }
  end
  
  def do_lifecycle
    case Calendar.season
    when :spring then do_reproduce
    when :summer then do_grow
    end
  end
  
  def do_reproduce
    if @resources.food >= (@population.size * 2 + 10)
      @population.children += 1
      @resources.food -= 10
    end
  end
  
  def do_grow
    (@population.children / (Calendar::DAYS_IN_SEASON - Calendar.day + 1)).times do
      @population.children -= 1
      role = case rand(1..100)
             when ( 1..40) then primary_foodie
             when (41..60) then secondary_foodie
             when (61..75) then :crafters
             when (76..95) then :warriors
             when (96..100) then :heroes
             else primary_foodie
             end
      @population[role] += 1 
    end
  end
  
  def primary_foodie
    @pf ||= begin
              c = @workable_cells.map {|cell| cell.terrain.class }
              c.count(Terrain::Grassland) >= c.count(Terrain::Forest) ? :farmers : :hunters
            end
  end
  
  def secondary_foodie
    primary_foodie == :farmers ? :hunters : :farmers
  end
  
  def self.random_name
    "TestName"
  end
end