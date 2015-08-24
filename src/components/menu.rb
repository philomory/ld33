class Menu
  class DSL
    def initialize(menu,&blk)
      @menu = menu
      self.instance_exec(&blk)
    end
    
    def menu_item(label,&blk)
      @menu.add_item MenuItem.new(label,&blk)
    end
    
    def header(&blk)
      @menu.header = blk
    end
  end
  
  attr_reader :items
  attr_accessor :header
  def initialize(&blk)
    @items = []
    @header = lambda { "Choose an option:" }
    DSL.new(self,&blk)
  end
  
  def add_item(item)
    @items << item
  end
  
  def active_items
    @items.select(&:active?)
  end
  
  class MenuItem
    class DSL
      def initialize(item,&blk)
        @item = item
        self.instance_exec(&blk)
      end
      
      def description(str)
        @item.instance_variable_set(:@description,str)
      end
      
      def on_select(&blk)
        @item.instance_variable_set(:@on_select,blk)
      end
      
      def active_when(&blk)
        @item.instance_variable_set(:@active_when,blk)
      end
    end
    
    attr_reader :description, :label, :on_select, :active_when
    def initialize(label,&blk)
      @label = label
      @description = "TEXT MISSING"
      @on_select = lambda {}
      @active_when = lambda { true }
      DSL.new(self,&blk)
    end
    
    def active?
      @active_when.call
    end
    
  end
  
end