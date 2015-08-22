# Based off code from http://d.hatena.ne.jp/ku-ma-me/20091004/p1
#
# An example usage is present in the __END__ section.

class Perlin
  
  def self.noise(x,y)
    main.perlin_noise(x,y)
  end
  
  def self.main
    @main ||= new(rand(65335),4,0.7)
  end
  
  def self.reseed(seed)
    @main = new(seed,4,0.7)
  end
  
  attr_accessor :seed, :octaves, :persistence
  def initialize(seed,octaves,persistence)
    @seed,@octaves,@persistence = seed,octaves,persistence
  end

  def noise(x,y)
    n = x + y * 57 + @seed * 131;
    n = (n << 13) ^ n;
    return (1.0 - ((n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0)
  end

  def smooth_noise(x, y)
    corners = noise(x-1, y-1) + noise(x-1, y+1) + noise(x+1, y-1) + noise(x+1, y+1)
    sides   = noise(x  , y-1) + noise(x  , y+1) + noise(x-1, y  ) + noise(x+1, y  )
    center  = noise(x  , y  )
    (center / 4) + (sides / 8) + (corners / 16)
  end

  def linear_interpolate(a, b, x)
    a * (1 - x) + b * x
  end

  def cosine_interpolate(a, b, x)
    f = (1 - Math.cos(x * Math::PI)) / 2
    a * (1 - f) + b * f
  end

  alias interpolate cosine_interpolate

  def interpolate_noise(x, y)
    interpolate(
      interpolate(
        smooth_noise(x.floor  , y.floor  ),
        smooth_noise(x.floor+1, y.floor  ),
        x - x.floor),
      interpolate(
        smooth_noise(x.floor  , y.floor+1),
        smooth_noise(x.floor+1, y.floor+1),
        x - x.floor),
      y - y.floor)
  end

  def perlin_noise(x, y)
    (0...@octaves).map do |i|
      frequency = 2.0 ** i
      amplitude = @persistence ** i
      interpolate_noise(x * frequency, y * frequency) * amplitude
    end.inject(0) {|sum,obj| sum + obj}
  end
end

__END__
# generate png
require "zlib"

width = height = 300
depth, color_type = 8, 2

pn = Perlin.new(1,4,0.25)

img_data = (0...height).map do |y|
  (0...width).map do |x|
    c = (pn.perlin_noise(x / 30.0, y / 30.0) * 255).floor & 255
    [c, c, c]
  end
end

def chunk(type, data)
  [data.bytesize, type, data, Zlib.crc32(type + data)].pack("NA4A*N")
end

print "\x89PNG\r\n\x1a\n"
print chunk("IHDR", [width, height, 8, 2, 0, 0, 0].pack("NNCCCCC"))
raw_data = img_data.map {|line| ([0] + line.flatten).pack("C*") }.join
print chunk("IDAT", Zlib::Deflate.deflate(raw_data))
print chunk("IEND", "")