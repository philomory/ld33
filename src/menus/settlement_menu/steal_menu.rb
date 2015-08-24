StealMenu = Menu.new do
  menu_item('Back') do
    description 'Go back to the previous menu'
    on_select { pop_menu }
  end
  
  menu_item('Steal Food') do
    description 'Sneak into town and steal some food'
    on_select { Game.steal(:food, from_settlement: screen.settlement) }
    active_when { screen.settlement.resources.food > 0 }
  end
  
  menu_item('Steal Gold') do
    description 'Sneak into town and steal some gold'
    on_select { Game.steal(:gold, from_settlement: screen.settlement) }
    active_when { screen.settlement.resources.gold > 0 }
  end
end