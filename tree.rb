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

  # traverses tree via breadth-first level
  # ... order
  # @return [Array] all the values of the tree
  def level_order_iter
    que = [@root]
    values = []

    until stack.empty?
      curr_node = stack.shift
      que << curr_node.left unless curr_node.left.nil?
      que << curr_node.right unless curr_node.right.nil?

      que << curr_node.data unless curr_node.data.nil?
    end

    values
  end

  # traverses inorder left root right
  # @param root [Node] root node
  def inorder(node = @root)
    return [] if node.nil?

    [inorder(node.left), node.data, inorder(node.right)].flatten
  end

  # preorder traversal root, right, left
  def preorder(node = @root)
    return [] if node.nil?

    [node.data, inorder(node.right), inorder(node.left)].flatten
  end

  # postorder traversal left, right, root
  def postorder(node = @root)
    return [] if node.nil?

    [inorder(node.left), inorder(node.right), node.data].flatten
  end

  def height(node = @root)
    return 0 if node.nil?
    return 0 if node.leaf?

    cummulative_height = 1
    right_height = height(node.right)
    left_height = height(node.left)

    right_height >= left_height ? cummulative_height + right_height : cummulative_height + left_height
  end

  # assuming node exist within tree
  # @param node [Node]
  def depth(node)
    node = Node.new(data: node) unless node.is_a?(Node)
    curr_node = @root
    depth = 0

    until node == curr_node
      curr_node = node < curr_node ? curr_node.left : curr_node.right
      depth += 1
    end

    depth
  end

  # @param node [Node]
  def balanced?(node = @root)
    return true if node.nil?

    left = node.left
    right = node.right

    height_dif = (height(left) - height(right)).abs

    if height_dif > 1
      false
    else
      true && balanced?(left) && balanced?(right)
    end
  end

  def rebalance
    @root = build_tree(inorder)

    return 'balanced'
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def build_tree(array)
    case array.size
    when nil then nil
    when 1 then Node.new(data: array[0])
    when 2 then Node.new(data: array[1], left: build_tree([array[0]]))
    else
      array.sort!
      array.uniq! unless array.uniq.nil?

      median = array.size / 2

      Node.new(data: array[median],
               left: build_tree(array[0...median]),
               right: build_tree(array[median + 1..-1]))
    end
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
  t = Tree.new(Array.new(15) { rand(1..100) })

  puts "2. t balanced: #{t.balanced?} \n "
  puts "3. \n #{t.preorder} \n #{t.postorder}  \n #{t.inorder}"
  Array.new(12) {rand(1..15)}.each do |el|
    t.insert(value: el)
  end
  puts "did insertions \n "

  puts "5. t balanced: #{t.balanced?} \n "

  t.rebalance
  puts "rebalanced \n"

  puts "6. t balanced: #{t.balanced?} \n "

  puts "8. \n #{t.preorder} \n #{t.postorder}  \n #{t.inorder}"
end
main