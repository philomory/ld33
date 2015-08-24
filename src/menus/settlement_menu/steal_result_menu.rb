StealResultMenu = Menu.new do
  header do |context|
    context
  end
  
  menu_item('Leave') do
    description 'Leave with your stolen goods.'
    on_select { Game.leave_settlement(screen.settlement) }
  end
end