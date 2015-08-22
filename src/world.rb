class World
  attr_reader :width, :height
  
  def initialize(width,height)
    @width, @height = width, height
    @grid = Grid.new(width,height) {|x,y| Cell.new(x,y) }
    generate_terrain
  end
  
  def draw
    @grid.each {|cell| cell.draw }
  end
  
  private
  
  def generate_terrain
    @grid.each_with_index do |cell,x,y|
      tmp_z = (Perlin.noise(x,y) * 255).to_i
      z = ((tmp_z+255)/2).to_i
      warn z unless z.between?(0,255)
      cell.terrain = Terrain.of_height(z).new(x,y,z)
    end
  end

end