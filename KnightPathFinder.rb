require_relative "../W3D5/Skeleton/lib/00_tree_node"
require 'byebug'
class KnightPathFinder
    attr_reader :path, :root_node, :considered_positions
    attr_accessor :position

   
    def self.valid_moves(pos)
        moves = [ [1, 2], [-1, -2], [-1, 2], [1, -2], [2, 1], [2, -1], [-2, -1], [-2, 1] ]
        # debugger
        x, y = pos
        valid = []
        moves.each do |position|
            posx, posy = position
            new_move = [x + posx, y + posy]
            valid << new_move if new_move.all? {|move| move >= 0 && move <= 7}
        end
        valid
    end

    def initialize(position)
        @position = position
        @path = [] #array of positions
        @considered_positions = []
    end
    
    def new_move_positions(pos)
        possible = KnightPathFinder.valid_moves(pos)
        options = possible.select {|move|!@considered_positions.include?(move)}
        @considered_positions += options
        options
    end

    def build_move_tree
        @root_node = PolyTreeNode.new(position)

        queue = [root_node]
        until queue.empty? 
            node = queue.shift
            self.new_move_positions(node.value).each do |child_pos|
                new_node = PolyTreeNode.new(child_pos)
                node.add_child(new_node)
                queue << new_node
            end
        end
    end

    def find_path(end_pos) #end_pos == node.value
       result = @root_node.dfs(end_pos)
       self.trace_path_back(result)
    end

    def trace_path_back(end_pos) #end_pos == node
        arr = [end_pos.value]

        parent_node = end_pos.parent  
        until parent_node.nil? #ps: until parent_node.value == @root_node.value 
            arr.unshift(parent_node.value)
            parent_node = parent_node.parent
        end
        arr#ps: arr.unshift(@root_node.value)
    end

end

kpf = KnightPathFinder.new([0, 0])
kpf.build_move_tree

# p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
# p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]
