require 'yaml'

class MonsterSpec
  def self.load(name)
    path = File.join(DATA_ROOT,'monsters',"#{name}.yml")
    data = YAML.load_file(path)
    new(data)
  end
  def initialize(data)
    @data = data
  end
  
  def health
    @data['health']
  end
  
  def resources
    d = @data['resources'] || {}
    r = Resources.new
    r.members.each do |member|
      r[member] = d[member] || 0
    end
    r
  end
  
  def food
    @data['resources']['food']
  end
  
  def gold
    @data['resources']['gold']
  end
  
  def name
    @data['name'] || 'monster'
  end
end