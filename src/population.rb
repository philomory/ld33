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
  
  def []=(role,num)
    raise ArgumentError.new("Invalid Role: #{role}") unless ROLES.include?(role)
    self.instance_variable_set(:"@#{role}",num)
  end
  
  def size
    ROLES.inject(0) {|total,role| total + self[role] }
  end
  
  def random_subset
    members = {}
    ROLES.map do |role|
      members[role] = rand(0..self[role])
    end
    if members.values.sum == 0
      members[most_common_role] = 1
    end
    if members.values.sum == self.size
      self
    else
      PopulationSubset.new(self,members)
    end
  end
  
  def solo
    PopulationSubset.new(self,{random_person => 1})
  end
    
  def random_person
    people = []
    ROLES.each do |role|
      people += ([role] * self[role])
    end
    people.sample
  end
    
  def most_common_role
    ROLES.sort_by {|role| self[role] }
  end
  
  def populated_roles
    ROLES.select {|role| self[role] > 0}
  end
  
  def to_hash
    hsh = {}
    ROLES.each do |role|
      hsh[role] = self[role]
    end
    hsh
  end
  
  STRENGTHS = {
    farmers: 3,
    hunters: 4,
    warriors: 10,
    children: 1,
    crafters: 2,
    heroes: 50
  }
  
  def strength
    ROLES.inject(0) do |acc,role|
      acc + (STRENGTHS[role] * self[role])
    end
  end
  
  def take_damage(num)
    deaths = {}
    loop do
      role = populated_roles.sample
      raise RuntimeError.new(role.inspect) unless STRENGTHS[role]
      break if STRENGTHS[role] > num
      self[role] -= 1
      deaths[role] ||= 0
      deaths[role] += 1
      num -= STRENGTHS[role]
      break if size == 0
    end
    deaths
  end
  
  def kill_random_person
    role = ROLES.select {|role| self[role] > 0 }.sample
    self[role] -= 1
  end
end