class Combat
  attr_reader :monster, :population, :location, :reason, :results, :orig_population
  def initialize(monster:,population:,location:,reason:)
    @monster, @population, @location, @reason = monster, population, location, reason
    @orig_population = @population.to_hash
    @luck_factor = rand(1..100)
  end
  
  def on_epic_win(&blk)
    @epic_win_callback = blk
  end
  
  def on_win(&blk)
    @win_callback = blk
  end
  
  def on_fail(&blk)
    @fail_callback = blk
  end
  
  def on_epic_fail(&blk)
    @epic_fail_callback = blk
  end
  
  def fight!
    raise if @results
    @results = true
    ems, ehs = effective_monster_strength, effective_human_strength
    deaths = @population.take_damage(ems)
    damage = @monster.take_damage(ehs)
    @results = CombatResult.new(self,deaths: deaths,damage: damage)
  end
  
  def effective_monster_strength
    factor = case @reason
             when :flee then 0.0
             when :fighting_retreat then 0.4
             when :kill then 1.0
             else raise "Blurgle!"
             end
    lscale = case @luck_factor
             when ( 1...33) then 0.8
             when (33...67) then 1.0
             when (67..100) then 1.2
             else raise "Wargle!"
             end
    (factor * lscale * @monster.strength).to_i
  end
  
  def effective_human_strength
    factor = case @reason
             when :flee
               case @luck_factor
               when ( 1...40) then 0.8
               when (40...60) then 0.6
               when (60...80) then 0.4
               when (80..100) then 0.0
               end
             when :fighting_retreat then 0.4
             when :kill then 1.0
             end
    lscale = case @luck_factor
             when ( 1...33) then 0.8
             when (33...67) then 1.0
             when (67..100) then 1.2
             end
    (factor * lscale * @population.strength).to_i
  end
  
  def finalize
    @population.merge! if @population.respond_to?(:merge!)
  end
end