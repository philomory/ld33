class MenuPane
  attr_reader :screen
  def initialize(screen,menu,context=nil)
    @screen = screen
    @menu_stack = [menu]
    @index_stack = [0]
    @context_stack = [context]
  end
  
  def draw
    draw_header
    draw_menu_items
    draw_menu_selected_description
  end
  
  def draw_header
    Gosu.translate(0,33) do
      header_text.lines.each_with_index do |line,index|
        small_font.draw(line.chomp,11,8*index,5,0.25,0.25)
      end
    end
  end
  
  def header_text
    blk = current_menu.header
    blk.arity.zero? ? blk.call : blk.call(current_context)
  end
  
  def draw_menu_items
    Gosu.translate(0,44+8*header_text.lines.count) do
      active_menu_items.each_with_index do |item,index|
        font.draw(item.label, 27, 16*index, 5, 0.25, 0.25 )
        if index == selected_index
          Game.monster.image.draw(11, 16*index - 3, 5)
        end
      end
    end
  end
  
  def draw_menu_selected_description
    Gosu.translate(0,194) do
      text = active_menu_items[selected_index].description
      small_font.draw(text, 11, 11, 5, 0.25, 0.25)
    end
  end
  
  def menu_move(adj)
    self.selected_index += adj
    self.selected_index %= active_menu_items.count
  end
  
  def menu_select
    proc = active_menu_items[selected_index].on_select
    self.instance_exec(&proc)
  end
  
  def push_menu(menu,context: nil)
    @menu_stack.push(menu)
    @index_stack.push(0)
    @context_stack.push(context)
  end
  
  def pop_menu
    @menu_stack.pop
    @index_stack.pop
    @context_stack.pop
  end
  
  def current_menu
    @menu_stack.last
  end
  
  def selected_index
    @index_stack.last
  end
  
  def current_context
    @context_stack.last
  end
  
  def selected_index=(value)
    @index_stack[-1] = value
  end
  
  def font
    @font ||= Gosu::Font.new(44, name: ImageManager.font_path('large'))
  end
  
  def small_font
    @small_font ||= Gosu::Font.new(28, name: ImageManager.font_path('small'))
  end
  
  def active_menu_items
    current_menu.items.select {|i| self.instance_exec(&i.active_when) }
  end
end