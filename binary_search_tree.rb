# Importing the unit test library
require "test/unit/assertions"
include Test::Unit::Assertions

# Class representing a single node of the binary tree
class Node
  include Comparable
  attr_accessor :data, :left_child, :right_child

  def initialize(data = nil, left_child = nil, right_child = nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

  # Returns the depth of a node
  def depth
    return 0 if nil?

    @accumulator_depth = 1
    depth_aux(self, @accumulator_depth)
    @accumulator_depth
  end

  # Aux function to depth
  def depth_aux(current_node, accumulator)
    @accumulator_depth = accumulator if accumulator > @accumulator_depth 
    depth_aux(current_node.left_child, accumulator + 1) unless current_node.left_child.nil?
    depth_aux(current_node.right_child, accumulator + 1) unless current_node.right_child.nil?
  end
end

# Class representing a Balanced Binary tree
class Tree
  attr_accessor :root

  def initialize(input_array)
    @root = build_tree(input_array)
  end

  # Consumes an input array and returns a balanced binary tree.
  def build_tree(input_array)
    sorted_set = input_array.sort.uniq
    build_tree_aux(sorted_set, 0, sorted_set.length - 1)
  end

  # Aux function to build_tree
  def build_tree_aux(input_array, start_index, stop_index)
    return nil if start_index > stop_index

    middle_index = (start_index + stop_index) / 2
    left_half = build_tree_aux(input_array, start_index, middle_index - 1)
    middle_value = input_array[middle_index]
    right_half = build_tree_aux(input_array, middle_index + 1, stop_index)
    Node.new(middle_value, left_half, right_half)
  end

  # Insert a value to the BBT, careful, this may unbalance the tree
  def insert(value)
    current_node = @root
    until current_node.nil?
      if current_node.data < value
        if current_node.right_child.nil?
          current_node.right_child = Node.new(value)
          break
        end
        current_node = current_node.right_child
      elsif current_node.data > value
        if current_node.left_child.nil?
          current_node.left_child = Node.new(value)
          break
        end
        current_node = current_node.left_child
      else
        puts 'Input error'
        break
      end
    end
  end

  # Delete a value from the BBT, careful, this may unbalance the tree
  def delete(value)
    current_node = @root
    until current_node.nil?
      if current_node.data < value
        next_node = current_node.right_child
        if next_node.data == value
          current_node.right_child = delete_aux(next_node, value)
          break
        end
        current_node = current_node.right_child
      elsif current_node.data > value
        next_node = current_node.left_child
        if next_node.data == value
          current_node.left_child = delete_aux(next_node, value)
          break
        end
        current_node = current_node.left_child
      elsif current_node.data == value
        @root = build_tree(in_order_traversal_internal(current_node) - [value])
        break
      end
    end
  end

  # Aux function to delete
  def delete_aux(next_node, value)
    return nil if next_node.right_child.nil? && next_node.left_child.nil?

    return next_node.left_child if next_node.right_child.nil?

    return next_node.right_child if next_node.left_child.nil?

    build_tree(in_order_traversal_internal(next_node) - [value])
  end

  # Consumes a value and return a Node if the value match the data in a Node
  def find(value)
    current_node = @root
    until current_node.nil?
      if current_node.data < value
        current_node = current_node.right_child
      elsif current_node.data > value
        current_node = current_node.left_child
      else
        return current_node
      end
    end
    return nil
  end

  # traverse the BBT in width and returns the data in level order in an array
  def level_order_traversal
    array_to_be_string = []
    queue = []
    queue.push(@root)
    until queue.empty?
      current_node = queue.first
      array_to_be_string.push(current_node.data)
      queue.push(current_node.left_child) unless current_node.left_child.nil?
      queue.push(current_node.right_child) unless current_node.right_child.nil?
      queue.shift
    end
    array_to_be_string
  end

  # traverse the BBT in depth and returns the data in order in an array
  def in_order_traversal
    current_node = @root
    in_order_traversal_internal(current_node)
  end

  # Aux function to in order traversal
  def in_order_traversal_internal(current_node)
    @accumulator = []
    in_order_traversal_aux(current_node)
    @accumulator
  end

  # Aux function to in order traversal
  def in_order_traversal_aux(current_node)
    in_order_traversal_aux(current_node.left_child) unless current_node.left_child.nil?
    @accumulator << current_node.data
    in_order_traversal_aux(current_node.right_child) unless current_node.right_child.nil?
  end

  # traverse the BBT in depth and returns the data in pre order in an array
  def pre_order_traversal
    current_node = @root
    pre_order_traversal_internal(current_node)
  end

  # Aux function to pre order traversal
  def pre_order_traversal_internal(current_node)
    @accumulator = []
    pre_order_traversal_aux(current_node)
    @accumulator
  end

  # Aux function to pre order traversal
  def pre_order_traversal_aux(current_node)
    @accumulator << current_node.data
    pre_order_traversal_aux(current_node.left_child) unless current_node.left_child.nil?
    pre_order_traversal_aux(current_node.right_child) unless current_node.right_child.nil?
  end

  # traverse the BBT in depth and returns the data in post order in an array
  def post_order_traversal
    current_node = @root
    post_order_traversal_internal(current_node)
  end

  # Aux function to post order traversal
  def post_order_traversal_internal(current_node)
    @accumulator = []
    post_order_traversal_aux(current_node)
    @accumulator
  end

  # Aux function to post order traversal
  def post_order_traversal_aux(current_node)
    post_order_traversal_aux(current_node.left_child) unless current_node.left_child.nil?
    post_order_traversal_aux(current_node.right_child) unless current_node.right_child.nil?
    @accumulator << current_node.data
  end

  # pretty print a BT
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  # Checks if a BT is balanced
  def balanced?
    difference_left_right = @root.left_child.depth - @root.right_child.depth
    difference_left_right.between?(-1, 1)
  end

  # Consumes a BT an returns a BBT
  def rebalance
    @root = build_tree(self.level_order_traversal) if !self.balanced?
  end
end

#unit_tests
sample_balanced_binary_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
sample_balanced_binary_tree.insert(6500)
sample_balanced_binary_tree.insert(2)
sample_balanced_binary_tree.insert(6)
sample_balanced_binary_tree.insert(10)
assert_equal sample_balanced_binary_tree.level_order_traversal, [8, 4, 67, 1, 5, 9, 324, 3, 7, 23, 6345, 2, 6, 10, 6500]
assert_equal sample_balanced_binary_tree.in_order_traversal, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 23, 67, 324, 6345, 6500]
assert_equal sample_balanced_binary_tree.pre_order_traversal, [8, 4, 1, 3, 2, 5, 7, 6, 67, 9, 23, 10, 324, 6345, 6500]
assert_equal sample_balanced_binary_tree.post_order_traversal, [2, 3, 1, 6, 7, 5, 4, 10, 23, 9, 6500, 6345, 324, 67, 8]
assert_equal sample_balanced_binary_tree.root.depth, 5
assert_equal Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]).root.depth, 4
assert_equal Tree.new([1, 7, 4, 8, 9, 4, 5, 9, 67]).root.depth, 3
assert_equal Tree.new([9]).root.depth, 1
assert_equal Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]).balanced?, true
sample_unbalanced_binary_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
sample_unbalanced_binary_tree.delete(3)
sample_unbalanced_binary_tree.delete(1)
sample_unbalanced_binary_tree.delete(7)
sample_unbalanced_binary_tree.delete(5)
assert_equal sample_unbalanced_binary_tree.balanced?, false
sample_unbalanced_binary_tree.rebalance
assert_equal sample_unbalanced_binary_tree.balanced?, true

# Driver script
driver_binary_tree = Tree.new(Array.new(15) { rand(1..100) })
puts driver_binary_tree.balanced?
p driver_binary_tree.level_order_traversal
p driver_binary_tree.in_order_traversal
p driver_binary_tree.pre_order_traversal
p driver_binary_tree.post_order_traversal
driver_binary_tree.insert(101)
driver_binary_tree.insert(102)
driver_binary_tree.insert(103)
driver_binary_tree.insert(104)
driver_binary_tree.insert(105)
driver_binary_tree.insert(106)
driver_binary_tree.insert(107)
driver_binary_tree.insert(108)
puts driver_binary_tree.balanced?
driver_binary_tree.rebalance
puts driver_binary_tree.balanced?
p driver_binary_tree.level_order_traversal
p driver_binary_tree.in_order_traversal
p driver_binary_tree.pre_order_traversal
p driver_binary_tree.post_order_traversal
driver_binary_tree.pretty_print
