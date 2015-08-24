Resources = Struct.new(:food,:gold,:lumber,:iron) do
  def randomly_distribute!(num_points)
    num_points.times { self[members.sample] += 1 }
  end
  def empty?
    food.zero? && gold.zero? && lumber.zero? && iron.zero?
  end
end