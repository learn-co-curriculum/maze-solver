require 'pry'

class MazeSolver
  attr_accessor :maze, :traveled_path, :visited_nodes, :node_queue
  START_DELIMITER = "→"
  END_DELIMITER = "@"
  VALID_NODES = [" ", START_DELIMITER, END_DELIMITER]

  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @solution_path = []
  end

  def maze_array
    @maze_array ||= parse_maze
  end

  def x_dimensions
    maze_array[0].size
  end

  def y_dimensions
    maze_array.collect{|row| row.size}.uniq.first
  end

  def start_coordinates
    maze_array.each_with_index do |row, row_index|
      row.each_with_index do |column, col_index|
        return [col_index, row_index] if column == START_DELIMITER
      end
    end
  end

  def end_coordinates
    maze_array.each_with_index do |row, row_index|
      row.each_with_index do |column, col_index|
        return [col_index, row_index] if column == END_DELIMITER
      end
    end
  end

  def node_value(coords)
    x,y = coords
    x <= x_dimensions && y <= y_dimensions ? maze_array[y][x] : nil
  end

  def valid_node?(coords)
    VALID_NODES.include?(node_value(coords))
  end

  def neighbors(coords)
    x,y = coords
    [[-1,0],[1,0],[0,1],[0,-1]].collect do |x_offset, y_offset|
      try_x, try_y = x + x_offset, y + y_offset
      valid_node?([try_x, try_y]) ? [try_x, try_y] : nil
    end.compact
  end

  def add_to_queues(to, from = start_coordinates)
    unless visited_nodes.include?(to)
      traveled_path << [to, from]
      visited_nodes << to 
      node_queue << to
    end
  end

  def move
    move_coords = node_queue.shift
    neighbors(move_coords).each do |coords|
      add_to_queues(coords, move_coords)
    end
  end

  def solve
    add_to_queues(start_coordinates)
    while !node_queue.empty?
      move
    end
    solution_path
  end

  def solution_path
    if @solution_path.empty?
      @solution_path << end_coordinates

      # This finds the movement that solved the maze, the node we moved from to
      # solve the maze
      last_traveled_step = traveled_path.detect do |step| 
        to_step = step[0]
        to_step == end_coordinates
      end

      # puts "The winning move was: #{last_traveled_step}"
      # Given the winning move, we need to find how we got there.
      # The second coordinate in the last_known_step_in_solution is the box
      # right before we won.

      # [[[10, 7], [9, 7]]] # the last step. It is a nested array because of select.
      # We're interested in the 9,7 because how did we get there?
      @solution_path << last_known_step_in_solution = last_traveled_step[1]

      # Until the last_known_step_in_solution is equal to the start of the maze, 
      # keep on adding those steps to the solution path
      i = 0
      until last_known_step_in_solution == start_coordinates
        i += 1
        # puts "Finding how we got to #{last_known_step_in_solution} (step #{i})..."
        last_known_step_in_solution = @traveled_path.detect do |step|
          to_step = step[0]
          to_step == last_known_step_in_solution
        end[1]
        @solution_path << last_known_step_in_solution
      end
    end
    @solution_path
  end

  def display_solution_path
    maze_canvas = maze_array.dup
    @solution_path[1..-2].each do |node|
      maze_canvas[node[1]][node[0]] = "."
    end

    string = ""
    maze_canvas.each do |row|
      string << "#{row.join}\n"
    end

    puts string.strip
  end

  private
    def parse_maze
      @maze.split(/\n/).collect{|row| row.strip.chars}
    end
end