class World
  attr_reader :width, :height
  
  def initialize(width,height)
    @width, @height = width, height
    @grid = Grid.new(width,height) {|x,y,g| Cell.new(x,y,g) }
    @tribes = []
    @settlements = []
    @wanderers = []
    generate_terrain
    generate_settlements(5)
  end
  
  def starting_cell
    @grid.select {|cell| cell.terrain.traversable? && !cell.settlement }.sample
  end
  
  def draw
    @grid.each {|cell| cell.draw }
  end
  
  def tick!
    @settlements.each(&:tick!)
    @wanderers.each(&:tick!)
  end
  
  def remove_settlement(settlement)
    @settlements.delete(settlement)
  end
  
  private
    
  def generate_terrain
    @grid.each_with_index do |cell,x,y|
      tmp_z = (Perlin.noise(x*0.2,y*0.2) * 255).to_i
      z = ((tmp_z+255)/2).to_i
      warn z unless z.between?(0,255)
      cell.terrain = Terrain.of_height(z).new(x,y,z)
    end
    f_png = Perlin.new(rand(65335),4,0.5)
    @grid.each_with_index do |cell,x,y|
      if !cell.terrain.is_a?(Terrain::Water) && f_png.perlin_noise(x*0.5,y*0.5) > 0.2
        cell.terrain = Terrain::Forest.new(x,y,cell.terrain.z)
      end
    end
  end
  
  def generate_settlements(num_settlements)
    locations = @grid.select {|cell| cell.terrain.settlements? }.sample(num_settlements).each do |cell|
      @tribes << (tribe = Tribe.new)
      population = Population.new(tribe, farmers: 6, hunters: 4, crafters: 1, warriors: 2)
      cell.around(3).select {|cell| cell.terrain.can_work? }.sample(5).each do |cell|
        role = case cell.terrain
               when Terrain::Forest    then :hunters
               when Terrain::Grassland then :farmers
               when Terrain::Mountain  then :crafters
               end
        population[role] += 1
      end
      resources = Resources.new(20,3,10,3)
      resources.randomly_distribute!(3)
      @settlements << (cell.settlement = Settlement.new(cell,population,resources))
    end
  end

end