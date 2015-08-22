Terrain = Struct.new(:x,:y,:z) do
  def cost; 0; end
  def traversable?; true; end
  def color; 0xFFFFFFFF; end
  def name
    self.class.name.downcase.split('::').last
  end
  def image
    ImageManager.image(name)
  end
end

class Terrain
  class OutOfBounds < Terrain
    def cost; 99999999; end
    def color; 0; end
    def traversable?; false; end
  end

  class Grassland < Terrain
    def color; 0xFF00FF00; end
  end
  
  class Water < Terrain
    def color; 0xFF0000FF; end
  end
  
  def self.of_height(z)
    case z
    when (  0...100) then Water
    else                  Grassland
    end
  end
  
end
    