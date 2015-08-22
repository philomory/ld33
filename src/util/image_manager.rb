module ImageManager
  module_function
  def image(name)
    @images ||= {}
    @images[name] ||= begin
                        filename = "#{name}.png"
                        path = File.join(MEDIA_ROOT,'images',filename)
                        Gosu::Image.new(path, retro: true)
                      end
  end
end