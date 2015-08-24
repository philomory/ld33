class DeadSettlementScreen < Screen
  
  def initialize(settlement,context: :abandoned)
    @settlement = settlement
    @context = context
  end
  
  def draw
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR) do
      draw_background
      draw_text
    end
  end
  
  def draw_background
    ImageManager.image('wall').draw(0,0,0,2,2)
  end
  
  def draw_text
    center = PIXEL_WIDTH/2
    message = case @context
              when :abandoned then "You come across an abandoned settlement.\nIn the ruins, you find:"
              when :killed then "You seem to have killed everyone here.\nIn the ruins, you find:"
              end
    message << "\n"
    if @settlement.resources.food > 0
      message << "#{@settlement.resources.food} food\n"
    end
    if @settlement.resources.gold > 0
      message << "#{@settlement.resources.gold} gold\n"
    end
    message << "\n"
    message << "You take it, and then trash what's left of the place."
    message << "\n\nPress Enter to continue."
    
    message.lines.each_with_index do |line,index|
      font.draw_rel(line.chomp,center,10+16*index,0,0.5,0.5,0.25,0.25)
    end
  end
  
  def button_down(id)
    case id
    when Gosu::KbEnter, Gosu::KbSpace, Gosu::KbReturn
      finalize
    end
  end
  
  def font
    ImageManager.font('large')
  end
  
  def finalize
    Game.monster.food += @settlement.resources.food
    Game.monster.gold += @settlement.resources.gold
    @settlement.remove_settlement
    Game.leave_settlement(nil)
  end

end