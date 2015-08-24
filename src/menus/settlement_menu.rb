SettlementMenu = Menu.new do
  menu_item('Leave quietly') do
    on_select { Game.leave_settlement(nil) }
    description "Leave quietly before you are seen."
  end
  
  menu_item('Steal stuff') do
    on_select { push_menu StealMenu }
    description "Steal stuff from them."
  end
  
  #menu_item('Destroy things') do
  #  on_select { push_menu DestroyMenu }
  #  description "Destroy things in the village."
  #end
  
  menu_item('Kill someone') do
    on_select { push_menu KillMenu }
    description "Murder someone in their sleep"
    active_when { Calendar.time_of_day == :night }
  end
  
  menu_item('Pick a fight') do
    on_select { push_menu FightMenu }
    description "Find someone to fight"
    active_when { Calendar.time_of_day == :day }
  end
end