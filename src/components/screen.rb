class Screen
  def update
  end
  
  def draw
  end
  
  def button_down(id)
  end
  
  def close
    w = Game.window
    if w.current_screen == self
      w.pop_screen
    end
  end
end