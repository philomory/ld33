class Population
  ROLES = %i{ farmers hunters warriors children crafters heroes }

  attr_reader :tribe
  attr_accessor *ROLES
  
  def initialize(tribe,people = {})
    @tribe = tribe
    ROLES.each do |role|
      value = people[role] || 0
      raise RangeError.new("Cannot have negative #{role}") if value < 0
      self.instance_variable_set(:"@#{role}", value)
    end
    raise ArgumentError.new("Must supply some people!") if size.zero?
  end
  
  def [](role)
    raise ArgumentError.new("Invalid Role: #{role}") unless ROLES.include?(role)
    self.instance_variable_get(:"@#{role}")
  end
  
  def size
    ROLES.inject(0) {|total,role| total + self[role] }
  end
    
end