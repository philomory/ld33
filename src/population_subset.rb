class PopulationSubset < Population
  def initialize(parent,members = {})
    @tribe = parent.tribe
    @parent = parent
    ROLES.each do |role|
      amount = members[role] || 0
      self[role] = amount 
      @parent[role] -= amount
    end
  end
  
  def merge!
    ROLES.each do |role|
      @parent[role] += self[role]
      self[role] = 0
    end
  end
  
  def separate!
    pop = Population.new(tribe,self.to_hash)
    ROLES.each {|role| self[role] = 0 }
    pop
  end
end