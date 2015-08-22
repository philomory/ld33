class Tribe
  attr_reader :name, :settlements
  def initialize(name=rand_name)
    @name = name
    @settlements = []
  end
  
  def rand_name
    "A Dummy Tribe Name"
  end
end