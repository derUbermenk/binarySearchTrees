class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    @data <=> other.data
  end

  # initializes a Node
  # @param data [Object]
  # @param right [Node]
  # @param left [Node]
  def initialize(data:, left: nil, right: nil)
    @data = data
    @left = left
    @right = right
  end

  def leaf?
    @left.nil? and @right.nil?
  end

  # returns the child of node if one childed node
  def child
    if (@left.nil? && @right.nil?) || (!@left.nil? && !@right.nil?)
      puts 'not one childed'
    elsif @left.nil?
      @right
    elsif @right.nil?
      @left
    end
  end

  # deletes a leaf of a node
  # @param node [Node] the node to delete
  def delete_leaf(node)
    case node.data
    when @right.data then @right = nil
    when @left.data then @left = nil
    end
  end

  # deletes child of one childed node
  # @param node [Node] the node to delete
  def delete_one_child_node(node)
    case node.data
    when @right.data then @right = node.child
    when @left.data then @left = node.child
    end
  end

  # deletes child of two childed node
  # @param node [Node] the node to delete
  def delete_two_child_node(node)
    # find replacement_value and store it in temp replacement node
    replacement_node = node.search_left_most_node_in_right

    # delete replacement node instance at actual tree
    node.delete_leaf(replacement_node)

    # set the left and right nodes of replacement node as the left
    # and right of the node to be deleted
    replacement_node.left = node.left
    replacement_node.right = node.right

    case node.data
    when @right.data then @right = replacement_node
    when @left.data then @left = replacement_node
    end
  end

  # searches the left most node of node arg
  # @param node [Node]
  # @return [Node]
  def search_left_most_node
    curr_node = self
    curr_node = curr_node.left until curr_node.leaf?
    curr_node
  end
end
