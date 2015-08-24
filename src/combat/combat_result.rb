class CombatResult
  attr_reader :messages
  def initialize(combat,deaths:,damage:)
    @combat, @deaths, @damage = combat, deaths, damage
    setup_messages
  end
  
  def setup_messages
    @messages = []
    who_you_fought
    what_you_tried
    who_you_killed
    what_happened_to_you
  end
  
  def who_you_fought
    message = "You faced "
    group = @combat.orig_population.select {|role,num| num > 0}
    message << describe_group(group)
    @messages << message
  end
  
  def what_you_tried
    @messages << case @combat.reason
                 when :flee
                   "You tried to flee at top speed."
                 when :fighting_retreat
                   "You tried to fight your way free."
                 when :fight_to_death
                   "You tried to kill as many of them as you could."
                 end
  end
  
  def describe_group(group)
    case group.size
    when 0
      "no one."
    when 1
      role = group.keys.first
      amount = group[role]
      "#{amount} #{role}."
    when 2
      group.keys.map {|role| "#{group[role]} #{role}"}.join(' and ') + "."
    else
      phrases = group.keys.map {|role| "#{group[role]} #{role}" }
      phrases[0..-2].join(", ") + "and #{phrases[-1]}."
    end
  end
  
  def who_you_killed
    unless @combat.reason == :flee
      message = "You managed to kill "
      message << describe_group(@deaths)
      @messages << message
    end
  end
  
  def what_happened_to_you
    monster = @combat.monster
    m = if monster.dead?
          "In the end, however... you perished."
        else
          case @damage
          when        0  then "You got through it all without a scratch."
          when ( 1...10) then "You got through with barely a scratch."
          when (10...25) then "You were roughed up a bit."
          when (25...50) then "You were seriously injured this time."
          when (50...99) then "You took a huge beating."
          else                "You were beaten to a pulp."
          end
        end
    @messages << m
  end
end