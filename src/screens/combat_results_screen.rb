class CombatResultsScreen < Screen
  def initialize(combat)
    @combat = combat
  end
  
  def draw
    Gosu.scale(SCALE_FACTOR,SCALE_FACTOR) do
      draw_background
      draw_results
      draw_press_enter
    end
  end
  
  def draw_background
    ImageManager.image('wall').draw(0,0,0,2,2)
  end
  
  def draw_results
    results.messages.each_with_index do |line,index|
      font.draw_rel(line, PIXEL_WIDTH/2,20+11*index,10,0.5,0.5,0.25,0.25)
    end
  end
  
  def draw_press_enter
    font.draw_rel("Press enter to continue.",PIXEL_WIDTH/2,200,10,0.5,0.5,0.25,0.25)
  end
  
  def font
    ImageManager.font('large')
  end
  
  def button_down(id)
    case id
    when Gosu::KbEnter, Gosu::KbSpace, Gosu::KbReturn then finalize
    end
  end
  
  def finalize
    @combat.finalize
    if @combat.monster.dead?
      Game.player_lost
    elsif @combat.location.settlement && @combat.location.settlement.population.size.zero?
      Game.window.push_screen DeadSettlementScreen.new(@combat.location.settlement,context: :killed)
    else
      Game.leave_settlement(nil) #TODO: fix this stupid api.
    end
  end
  
  def results
    @combat.results
  end
end