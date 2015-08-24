DestroyMenu = Menu.new do
  menu_item('Back') do
    description 'Go back to the previous menu'
    on_select { pop_menu }
  end
  
  menu_item('Destroy Food') do
    description 'Sneak into town and ruin their food'
    on_select { Game.destroy(:food, from_settlement: screen.settlement) }
    active_when { screen.settlement.resources.food > 0 }
  end
end