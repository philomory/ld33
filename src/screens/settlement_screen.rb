class SettlementScreen < Screen
  attr_reader :settlement, :menu_pane
  def initialize(settlement)
    @settlement = settlement
    setup_menu
    #@settlement_label ||= Gosu::Image.from_text('This is a test',44,font: font, retro: true)
  end
  
  def background
    @bg ||= ImageManager.image('wall')
  end
  
  def draw
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR,0,0) do
      background.draw(0,0,0,2,2)
      draw_text
      draw_menu
    end
  end
  
  def draw_text
    font.draw("The #{@settlement.rank_name} of #{@settlement.name}",11,11,5,0.25, 0.25)
    font.draw("Population: #{@settlement.population.size}", 11, 33 ,5, 0.25, 0.25 )
    Population::ROLES.each_with_index do |member, index|
      font.draw("#{member.capitalize}: #{@settlement.population[member]}", 16, 44+11*index,5,0.25, 0.25 )
    end
    offset = 55+11*(Population::ROLES.count)
    font.draw("Resources:",11, offset, 5, 0.25, 0.25)
    Resources.members.each_with_index do |member, index|
      font.draw("#{member.capitalize}: #{@settlement.resources[member]}", 16, offset+11+11*index, 5, 0.25, 0.25)
    end
  end
  
  def draw_menu
    Gosu.translate(120,0) do
      @menu_pane.draw
    end
  end
  
  def font
    @font ||= Gosu::Font.new(44, name: ImageManager.font_path('large'))
  end
  
  def small_font
    @small_font ||= Gosu::Font.new(28, name: ImageManager.font_path('small'))
  end
  
  def button_down(id)
    case id
    when Gosu::KbUp   then @menu_pane.menu_move(-1)
    when Gosu::KbDown then @menu_pane.menu_move(+1)
    when Gosu::KbSpace, Gosu::KbEnter, Gosu::KbReturn then @menu_pane.menu_select
    end
  end
    
  def steal
    Game.steal_from_settlement(@settlement)
  end
  
  def setup_menu
    @menu_pane = MenuPane.new(self,SettlementMenu)
    @selected_index = 0
  end
end