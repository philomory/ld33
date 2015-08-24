class Grid
  include Enumerable
  attr_reader :width, :height
  
  def initialize(width, height, &blk)
    @width, @height = width, height
    @contents = Array.new(width) do |x|
      Array.new(height) do |y|
        if block_given?
          blk.call(x,y,self)
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
    if x.between?(0,width-1) && y.between?(0,height-1)
      @contents[x][y]
    else
      Cell::OutOfBounds.new(x,y,self)
    end
  end
  
  def []=(x,y,val)
    @contents[x][y] = val
  end
  
  def valence(x,y,radius)
    select {|cell| ((cell.x - x).abs + (cell.y-y).abs) == radius }
  end

  def around(x,y,radius)
    select {|cell| ((cell.x - x).abs + (cell.y-y).abs) <= radius }
  end

end