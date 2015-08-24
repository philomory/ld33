FightMenu = Menu.new do
  header { "Who do you want to fight?" }
  
  menu_item('Back') do
    description 'Go back to the previous menu'
    on_select { pop_menu }
  end
  
  menu_item('One person') do
    description 'Seperate one person and fight them alone.'
    on_select { Game.fight_to_kill(screen.settlement,pop: screen.settlement.population.solo) }
  end
  
  menu_item('A group') do
    description 'Fight a group of people'
    on_select { Game.fight_to_kill(screen.settlement,pop: screen.settlement.population.random_subset) }
  end
  
  menu_item("The whole town") do
    description 'Fight the whole town at once!'
    on_select { Game.fight_to_kill(screen.settlement,pop: screen.settlement.population) }
  end
end