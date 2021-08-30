require 'pry-byebug'
require_relative 'node'

class Tree
  attr_accessor :root
  # @param array [Array] array to be converted to tree
  def initialize(array)
    @root = build_tree(array)
  end

  def insert(value:, curr_node: self.root)
    additional_node = Node.new(data: value)
    if additional_node == curr_node
      curr_node
    elsif additional_node < curr_node
      return curr_node.left = additional_node if curr_node.left.nil?

      curr_node = curr_node.left
      insert(value: value, curr_node: curr_node)
    elsif additional_node > curr_node
      return curr_node.right = additional_node if curr_node.right.nil?

      curr_node = curr_node.right
      insert(value: value, curr_node: curr_node)
    end
  end

  def delete(value)
    node_to_delete = Node.new(data: value)
    return @root.delete_two_child_node(@root) if node_to_delete == @root

    parent = find(value, true)
    node = node_to_delete < parent ? parent.left : parent.right

    if node.leaf?
      parent.delete_leaf(node)
    elsif node.has_one_child
      parent.delete_one_child_node(node)
    else
      parent.delete_two_child_node(node)
    end
  end

  # searches for node and parent of a node if specified
  # @param node [Node]
  # return [Node]
  def find(value, find_parent = false)
    node_to_find = Node.new(data: value)
    parent = self.root
    node = Node.new(data: nil)

    until parent.leaf?

      node = parent.left if node_to_find < parent
      node = parent.right if node_to_find > parent
      return parent if node_to_find == parent

      return find_parent ? parent : node if node == node_to_find 

      parent = node
    end
  end

  private

  def build_tree(array)
    return Node.new(data: array[0]) if array.size == 1

    array.sort!
    array.uniq! unless array.uniq.nil?

    median = array.size / 2

    Node.new(data: array[median],
             left: build_tree(array[0...median]),
             right: build_tree(array[median + 1..-1]))
  end

  # gets the median of an array
  # @param array [Array]
  def get_median_index(array)
    # assuming that we want left branch to be smaller if array size is odd
    # when array size is even, set median to size / 2 - 1

    return array.size / 2 - 1 if array.size.even?

    array(array.size / 2)
  end
end

def main
  a = Tree.new([1, 2, 3, 4, 5, 6, 7])
  binding.pry
end
main