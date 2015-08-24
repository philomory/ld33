require 'yaml'

module ImageManager
  class << self
    # def image(name)
    #   @images ||= {}
    #   @images[name] ||= begin
    #                       filename = "#{name}.png"
    #                       path = File.join(MEDIA_ROOT,'images',filename)
    #                       Gosu::Image.new(path, retro: true)
    #                     end
    # end
    #
    # def setup
    #   tilepath = File.join(MEDIA_ROOT,'images','basictiles_2.png')
    #   tiles = Gosu::Image.load_tiles(tilepath,16,16,retro: true)
    # end
  
    def image(name)
      @images ||= {}
      @images[name] ||= _load_image_named(name)
    end
    
    def font(name)
      @fonts ||= {}
      @fonts[name] ||= _load_font_named(name)
    end
    
    def font_path(name)
      @font_paths ||= {}
      @font_paths[name] ||= File.join(MEDIA_ROOT,'fonts',_font_map[name]['path'])
    end
  
    private
    
    def _load_font_named(name)
      data = _font_map[name]
      path = File.join(MEDIA_ROOT,'fonts',data['path'])
      Gosu::Font.new(data['size'],name: path)
    end
    
    def _font_map
      @_font_map ||= YAML.load_file(File.join(DATA_ROOT,'fonts.yml'))
    end
  
    def _load_image_named(name)
      data = _mapping[name]
      if data.has_key?('set')
        _tiles(data['set'])[data['index']]
      elsif data.has_key?('image')
        path = File.join(MEDIA_ROOT,'images',data['image'])
        Gosu::Image.new(path,retro: true)
      end
    end
  
    def _mapping
      @_mapping ||= YAML.load_file(File.join(DATA_ROOT,'tilemaps.yml'))
    end
  
    def _tiles(set)
      @_tiles ||= {}
      @_tiles[set] ||= _load_tiles(set)
    end
  
    def _load_tiles(set)
      path = File.join(MEDIA_ROOT,'tilesets',set)
      Gosu::Image.load_tiles(path,16,16,retro: true)
    end
  end
  
end