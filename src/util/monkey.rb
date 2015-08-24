class Array
  def sum
    inject(0) {|acc,inc| acc + inc }
  end
end