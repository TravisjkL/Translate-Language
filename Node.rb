class Node
  attr_accessor :value, :next

  def Node.new_x(x)
    tmp = Node.new
    tmp.value = x
    tmp.next = nil
    tmp
  end

end