KillMenu = Menu.new do
  menu_item('Back') do
    description 'Go back to the previous menu'
    on_select { pop_menu }
  end
  
  menu_item('Kill and eat someone') do
    description 'Sneak into town, murder someone in their sleep, and eat them.'
    on_select { Game.kill(:eat,from_settlement: screen.settlement) }
  end
  
  menu_item('Kill and desecrate someone') do
    description 'Sneak into town, murder someone in their sleep, and desecrate their corpse.'
    on_select { Game.kill(:desecrate, from_settlement: screen.settlement) }
  end
end