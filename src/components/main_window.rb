class MainWindow < Gosu::Window
  
  def initialize
    super(WINDOW_WIDTH,WINDOW_HEIGHT)
    @screen_stack = []
  end
  
  def button_down(id)
    if id == Gosu::KbEscape
      close
    else
      current_screen.button_down(id)
    end
  end
  
  def update
    current_screen.update
  end
  
  def draw
    Gosu.translate(0,HUD_HEIGHT) do
      current_screen.draw
    end
    draw_hud
  end
  
  def draw_hud
    font = ImageManager.font('small')
    date = "Y: #{Calendar.year} S: #{Calendar.season.to_s.capitalize} D: #{Calendar.day} (#{Calendar.time_of_day.to_s.capitalize})"
    health = "Health: #{Game.monster.health}"
    food = "Food: #{Game.monster.food}"
    if Game.monster.food == 0
      food = "<c=FF0000>#{food}</c>"
    end
    gold = "Gold: #{Game.monster.gold}"
    hud_line = "#{health}     #{food}    #{gold}"
    font.draw(date,5,0,0)
    font.draw_rel(hud_line,SCREEN_WIDTH-5,0,0,1.0,0.0)
  end
  
  def current_screen
    @screen_stack.last
  end
  
  def current_screen=(new_screen)
    @screen_stack = [new_screen]
  end
  
  def push_screen(screen)
    @screen_stack.push(screen)
  end 
  
  def pop_screen
    @screen_stack.pop
  end

end