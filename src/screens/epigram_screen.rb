require 'yaml'

class EpigramScreen < Sequence
  class Part
    attr_accessor :alpha, :pause, :duration
    def initialize(text:, x:, y:,pause: 0.75,duration:1.5)
      @text = text
      @x, @y = x, y
      @pause, @duration = pause, duration
      @alpha = 0
    end
    
    def color
      @alpha * 0x01000000 + 0x00FFFFFF
    end
    
    def draw
      font.draw(@text,@x,@y,0,0.25,0.25,color)
    end
    
    def font
      ImageManager.font('large')
    end
  end
  
  def initialize(key,&blk)
    @done_callback = blk
    @parts = _load_parts(key)
    
    @parts.each do |part|
      subseq(part.duration) do |portion|
        part.alpha = (portion * 0xFF).floor
      end
      subseq(part.pause) {|_| }
    end
    subseq(0.75) {|_| }
    subseq(1) do |portion|
      alpha = ((1-portion) * 0xFF).floor
      @parts.each {|p| p.alpha = alpha }
    end
  end
  
  def draw
    super
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR) do
      @parts.each {|part| part.draw }
    end
  end
  
  def done
    @done_callback.call
  end
  
  def button_down(id)
    case id
    when Gosu::KbEnter, Gosu::KbSpace, Gosu::KbReturn then done
    end
  end
    
  
  private
  def _load_parts(key)
    path = File.join(DATA_ROOT,'epigrams.yml')
    data = YAML.load_file(path)
    parts = data[key]
    parts.map {|hsh| Part.new(**hsh) }
  end
end