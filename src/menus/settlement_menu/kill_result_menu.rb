KillResultMenu = Menu.new do
  header do |context|
    message = "You sneak in, kill one of the #{context[:role].to_s},\n"
    if context[:goal].to_s == :eat
      message << "and eat their corpse."
    else
      message << "and strew their entrails around the place."
    end
    message
  end
  
  menu_item('Leave') do
    description 'Sneak back out again.'
    on_select { Game.leave_settlement(screen.settlement) }
  end
end