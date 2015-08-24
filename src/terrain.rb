Terrain = Struct.new(:x,:y,:z) do
  def cost; 0; end
  def traversable?; true; end
  def settlements?; true; end
  def color; 0xFFFFFFFF; end
  def name
    self.class.name.downcase.split('::').last
  end
  def imagename
    name
  end
  def image
    ImageManager.image(imagename)
  end
  def draw(xpos,ypos)
    image.draw(xpos,ypos,0)
  end
  def can_work?
    true
  end
  def work_result(role)
    {food: 1}
  end
end

class Terrain
  class OutOfBounds < Terrain
    def cost; 99999999; end
    def color; 0; end
    def traversable?; false; end
    def settlements?; false; end
    def can_work?; false; end
  end

  class Grassland < Terrain
    def imagename
      @imagename ||= "grassland_#{rand(4)}"
    end
    def work_result(role)
      base_food = (role == :farmers ? rand(1..3) : 1)
      case Calendar.season
      when :winter then {food: [0,1,1].sample}
      when :spring then {food: base_food}
      when :summer then {food: base_food+1}
      when :fall   then {food: base_food}
      end 
    end
  end
  
  class Forest < Terrain
    def imagename
      @imagename ||= "forest_#{rand(2)}"
    end
    def draw(xpos,ypos)
      ImageManager.image('grassland_0').draw(xpos,ypos,0)
      image.draw(xpos,ypos,0)
    end
    def work_result(role)
      case role
      when :farmers
        case Calendar.season
        when :winter then {food: rand(0..1), lumber: 1 }
        when :spring then {food: 2}
        when :summer then {food: 1}
        when :fall   then {food: 1}
        end
      when :hunters
        case Calendar.season
        when :winter then {food: 1}
        when :spring then {food: 3}
        when :summer then {food: 2}
        when :fall   then {food: 2}
        end
      when :crafters
        {lumber: [1,1,2].sample }
      end
    end
  end
  
  class Mountain < Terrain
    def initialize(*args)
      super(*args)
      @resource = [nil,nil,nil,:iron,:iron,:gold].sample
    end
    def imagename
      @imagename ||= "mountain_#{rand(2)}"
    end
    def draw(xpos,ypos)
      ImageManager.image('grassland_0').draw(xpos,ypos,0)
      image.draw(xpos,ypos,0)
    end
    
    def work_result(role)
      case @resource
      when nil then {food: [0,0,1].sample }
      when :iron then {iron: rand(1..2) }
      when :gold then {gold: rand(0..1) }
      end
    end
  end
  
  class Water < Terrain;
    def settlements?
      false
    end
    def can_work?
      false
    end
  end
    
  def self.of_height(z)
    case z
    when (  0...50 ) then Water
    when ( 50...175) then Grassland
    else                  Mountain
    end
  end
  
end
    