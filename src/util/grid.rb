class Grid
  include Enumerable
  attr_reader :width, :height
  
  def initialize(width, height, &blk)
    @width, @height = width, height
    @contents = Array.new(width) do |x|
      Array.new(height) do |y|
        if block_given?
          blk.call(x,y)
        end
      end
    end
  end
  
  def each(&blk)
    @contents.each do |row|
      row.each do |element|
        blk.call(element)
      end
    end
  end
  
  def each_with_index(&blk)
    @contents.each_with_index do |row, x|
      row.each_with_index do |element, y|
        blk.call(element,x,y)
      end
    end
  end

  def [](x,y)
    @contents[x][y]
  end
  
  def []=(x,y,val)
    @contents[x][y] = val
  end

end