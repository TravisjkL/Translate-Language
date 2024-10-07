require_relative 'Node.rb'

class LinkedList
  attr_reader :first, :last, :size

  def initialize
    @size = 0
  end

  def add(value)
    if @first.nil?
      @first = @last = Node.new_x(value)
    else
      newNode = Node.new_x(value)
      @last.next = newNode
      @last = @last.next
    end
    @size += 1
  end

  def empty
    if (@first == nil) and (@last == nil)
      true
    else
      false
    end
  end
end