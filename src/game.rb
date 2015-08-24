module Game
  class << self
    attr_reader :world, :monster, :window
  
    def play!
      setup_game
      setup_window
      display_window
    end
    
    def monster_entered_settlement(settlement)
      if settlement.dead?
        @window.push_screen DeadSettlementScreen.new(settlement)
      else
        @window.push_screen SettlementScreen.new(settlement)
      end
    end
    
    def steal(resource, from_settlement:)
      if successfully_sneak_into?(from_settlement)
        grab(resource,from_settlement: from_settlement)
      else
        get_caught(at_settlement: from_settlement)
      end
    end
    
    def kill(goal, from_settlement:)
      if successfully_sneak_into?(from_settlement)
        murder(goal,from_settlement: from_settlement)
      else
        get_caught(at_settlement: from_settlement)
      end
    end
    
    def murder(goal, from_settlement:)
      role = from_settlement.population.random_person
      from_settlement.population[role] -= 1
      @monster.food += 5 if goal == :eat
      @window.current_screen.menu_pane.push_menu(KillResultMenu, context: {role: role, goal: goal})
    end
    
    def successfully_sneak_into?(settlement)
      rand(2).zero? # TODO: make this compare monster and settlement
    end
    
    def grab(resource, from_settlement:)
      from_settlement.resources[resource] -= 1 #TODO: dynamic amount
      resource == :food ? @monster.food += 1 : @monster.gold += 1
      @window.current_screen.menu_pane.push_menu(StealResultMenu, context: "You successfully stole 1 #{resource}")
    end
    
    def get_caught(at_settlement:)
      @window.current_screen.menu_pane.push_menu(CaughtMenu,context: at_settlement.population.random_subset)
    end
    
    def leave_settlement(s)
      until @window.current_screen.is_a?(MapScreen)
        @window.pop_screen
      end
      tick!
    end
    
    def flee_from_settlement(settlement, pop:)
      c = Combat.new(monster:@monster,population:pop,location:settlement.cell,reason: :flee)
      c.fight!
      @window.push_screen CombatResultsScreen.new(c)
    end
  
    def fight_to_escape(settlement,pop:)
      c = Combat.new(monster:@monster,population:pop,location:settlement.cell,reason: :fighting_retreat)
      c.fight!
      @window.push_screen CombatResultsScreen.new(c)
    end
    
    def fight_to_kill(settlement,pop:)
      c = Combat.new(monster:@monster,population:pop,location:settlement.cell,reason: :kill)
      c.fight!
      @window.push_screen CombatResultsScreen.new(c)
    end
  
    def start
      @window.current_screen = MapScreen.new(@world,@monster)
    end
    
    def tick!
      @monster.tick!
      @world.tick!
      Calendar.tick!
    end
        
    def setup_game
      Calendar.reset!
      @world = World.new(WORLD_WIDTH,WORLD_HEIGHT)
      start_cell = @world.starting_cell
      spec = MonsterSpec.load('grendel')
      @monster = Monster.new(start_cell,spec)
    end

    def setup_window
      @window = MainWindow.new
      @window.current_screen = EpigramScreen.new('gold') do
        start
      end
    end
    
    def display_window
      @window.show
    end
    
    def player_lost
      @window.current_screen = EpigramScreen.new('accident') do
        exit
      end
    end
    
  end
end