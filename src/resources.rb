Resources = Struct.new(:livestock,:wealth,:lumber,:crops,:weapons) do
  def randomly_distribute!(num_points)
    num_points.times { self[members.sample] += 1 }
  end
end