describe 'MazeSolver' do
  let(:small_maze){
    <<-11x11
      ###########
      #         #
      # ####### #
      →         #
      ### # ### #
      #     #   #
      # ##### ###
      # #   #   @
      # ### # ###
      #         #
      ###########
    11x11
  }

  let(:maze_solver) { MazeSolver.new(small_maze) }

  context "A new maze solver" do
    it "instantiates with the maze as an attribute" do
      expect(maze_solver.maze).to eq(small_maze)
    end

    it 'instantiates with empty arrays for traveled_path, visited_nodes, node_queue' do
      expect(maze_solver.traveled_path).to eq([])
      expect(maze_solver.visited_nodes).to eq([])
      expect(maze_solver.node_queue).to eq([])
    end
  end

  context 'Parsing a maze' do
    let(:maze_array) {MazeSolver.new(small_maze).maze_array}

    it 'converts the maze to an array' do
      maze_array_fixture = [
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", "#", "#", " ", "#"],
        ["→", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", " ", "#", " ", "#", "#", "#", " ", "#"],
        ["#", " ", " ", " ", " ", " ", "#", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"],
        ["#", " ", "#", " ", " ", " ", "#", " ", " ", " ", "@"],
        ["#", " ", "#", "#", "#", " ", "#", " ", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"]
      ]
      expect(maze_array).to eq(maze_array_fixture)
    end
      
    it 'represents the dimensions of the maze' do
      expect(maze_array.size).to eq(11)
      maze_array.each do |row|
        expect(row.size).to eq(11)
      end

      expect(maze_solver.x_dimensions).to eq(11)
      expect(maze_solver.y_dimensions).to eq(11)
    end

    it 'finds the maze start coordinates' do
      expect(maze_solver.start_coordinates).to eq([0,3])
    end

    it 'finds the maze end coordinates' do
      expect(maze_solver.end_coordinates).to eq([10,7])
    end

  end

  context 'Neighbors and nodes' do
    it 'finds the tile value for a node' do
      expect(maze_solver.node_value([0,0])).to eq("#")
      expect(maze_solver.node_value([1,3])).to eq(" ")
      expect(maze_solver.node_value([12,12])).to be_nil
    end

    it 'knows whether a node is a valid tile path' do
      expect(maze_solver.valid_node?([12,12])).to be_falsey
      expect(maze_solver.valid_node?([0,0])).to be_falsey
      expect(maze_solver.valid_node?([1,3])).to be_truthy
    end

    it 'finds non-blocked neighboring nodes for a given coordinate' do
      expect(maze_solver.neighbors([0,3])).to eq([[1,3]])
    end
  end

  context 'Queues and Stacks' do
    describe '#add_to_queues' do
      it 'adds a node to the queues and stacks of the maze solution' do
        maze_solver.add_to_queues([0,3], [0,3])

        expect(maze_solver.node_queue).to include([0,3])
        expect(maze_solver.traveled_path[0]).to include([0,3])
        expect(maze_solver.visited_nodes).to include([0,3])

        maze_solver.add_to_queues([1,3], [0,3])

        expect(maze_solver.node_queue).to include([1,3])
        expect(maze_solver.traveled_path[1]).to include([1,3])
        expect(maze_solver.visited_nodes).to include([1,3])
      end
    end
  end

  describe '#move' do
    it 'shifts the first node out of the node_queue' do
      maze_solver.add_to_queues([0,3])
      maze_solver.move

      expect(maze_solver.node_queue).not_to include([0,3])
    end

    it 'adds the neighbors of a node to the node queue' do
      maze_solver.add_to_queues([0,3])
      maze_solver.move

      expect(maze_solver.node_queue).to include([1,3])
    end

    it "doesn't traverse visited_nodes" do
      maze_solver.node_queue = [[0,3]]
      maze_solver.move

      maze_solver.node_queue = [[0,3]]
      maze_solver.move

      expect(maze_solver.visited_nodes.size).to eq(1)
    end
  end

  context 'Solving a maze' do
    describe '#solve' do
      it 'visits nodes and keeps track of them in the visited_nodes array' do
        maze_solver.solve

        # We're going to assume that at least 0,3 and 1,3 will be moved through
        # in an at all functioning solve routine.
        expect(maze_solver.visited_nodes).to include([0,3])
        expect(maze_solver.visited_nodes).to include([1,3])
      end
    end

    describe '#solution_path' do
      it 'returns the solution path array' do
        maze_solver.solve

        # We're using nodes that absolutely must be traveled to in order to confirm a solution path,
        # as mazes might include more than one solution.
        solution_must_contain = [[0, 3], [7, 5], [7, 6], [7, 7], [8, 7], [9, 7], [10,7]]

        solution_must_contain.each do |node|
          expect(maze_solver.solution_path).to include(node)
        end
      end
    end

    # It is possible
    describe '#display_solution_path' do
      it 'prints out the solved maze' do
        # There is another possible solution so don't worry
        # if this test fails.

        @solution_string = "
###########
#         #
# ####### #
→.........#
### # ###.#
#     #...#
# #####.###
# #   #...@
# ### # ###
#         #
###########".strip

        maze_solver.solve
        # expect($stdout).to receive(:puts).with(@solution_string)

        maze_solver.display_solution_path
      end
    end

  end
end
