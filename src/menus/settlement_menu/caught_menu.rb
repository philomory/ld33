CaughtMenu = Menu.new do
  header do |context|
    h = "You tried to sneak into the town, but you were caught!\n"
    h << "You are facing "
    ary = Population::ROLES.map {|role| "#{context[role]} #{role.to_s}"}
    h << ary[0..2].join(", ")
    h << ",\n"
    h << ary[3..-2].each_slice(4).map {|slice| slice.join(", ")}.join("\n")
    h << ", and #{ary[-1]}."
    h
  end
  
  menu_item('Try to run') do
    description 'Try to run away without getting hurt.'
    on_select { Game.flee_from_settlement(screen.settlement,pop: current_context) }
  end
  
  menu_item('Fight to escape') do
    description 'Try to fight your way free.'
    on_select { Game.fight_to_escape(screen.settlement, pop: current_context) }
  end
  
  menu_item('Fight to kill') do
    description 'Kill everyone who stands in your way.'
    on_select { Game.fight_to_kill(screen.settlement, pop: current_context) }
  end
end