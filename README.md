---
tags: BFS, DFS
languages: ruby
---

# Objective

Implement a Breadth First Search algorithm to solve a maze programmatically. 

# Introduction

The [Breadth First Search](http://en.wikipedia.org/wiki/Breadth-first_search) algorithm is a common way to solve node-based path executions. Given a graph of nodes, BFS will basically collect all the possible paths that can be traveled, and visit them until the destination node is reached. This [4 Minute Video on BFS](http://www.youtube.com/watch?v=QRq6p9s8NVg) explains it well.

The basic psuedocode can be described as:

    bfs(start, looking_for)
      create arrays (node_queue, visited_nodes, and traveled_path)
      add the start to the arrays
      while the queue is not empty
        take out the first element in the queue
        for each of the neighbors of this first element 
          if its not in the visited set and not blocked
            add this to the arrays
            if this contains what we are looking for
              return the backtrack of this node
            end if
          end if
        end for
      end while
    end method

There are three arrays we create, `node_queue`, `visited_nodes`, and `traveled_path` are storing data about the progress of the BFS.

- `node_queue` is storing nodes to travel.
- `visited_nodes` is storing nodes already traveled.
- `traveled_path` is storing nodes that traveled, have led to the destination.

Make sure to wrap your head around how BFS works in theory before trying to implement it. Watching that video and reading the Wikipedia article should help. There is also a [Flatiron presentation of BFS](https://docs.google.com/presentation/d/1gBm5YShcyAu_sfUFszCIJsKjz9dZDAmT7GOkjt-tj6s/edit?usp=sharing).

## Notes on Implementing BFS to Solve a Maze

Our mazes are represented as strings.

    ###########
    #         #
    # ##### ###
    →   #     #
    ### # ### #
    #     #   #
    # ##### ###
    # #   #   *
    # ### #####
    #         #
    ###########

This represents an 11x11 Maze. The start of the maze is represented by `→` and the end of the maze by a `@`. The `#` represents a wall. The solution to this maze could be represented as:

    ###########
    #         #
    # ##### ###
    →...#.....#
    ###.#.###.#
    #  ...#...#
    # #####.###
    # #   #...@
    # ### #####
    #         #
    ###########

Your goal is to deliver a class, `MazeSolver`, that when initialized with a string of the maze, can solve it.

Instances of `MazeSolver` should respond to a `#solve` method that populates a `@solution_path` instance variable to store an ordered array that describes the path, the moves to take to solve the maze, from start, to finish. Something like:

    [
        [0, 3],
        [1, 3],
        [2, 3],
        [3, 3],
        [3, 4],
        [3, 5],
        [4, 5],
        [5, 5],
        [5, 4],
        [5, 3],
        [6, 3],
        [7, 3],
        [8, 3],
        [9, 3],
        [9, 4],
        [9, 5],
        [8, 5],
        [7, 5],
        [7, 6],
        [7, 7],
        [8, 7],
        [9, 7],
        [10,7]
    ]

This instance variable should be exposed via a `#solution_path` method.

Additionally, you can choose to implement a method `#display_solution` that prints out the solved mazes with `.`s representing the solution path, as above.

In order to solve this maze, you must (or should) convert this maze to an array:
    
    [
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"],
        ["→", " ", " ", " ", "#", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", " ", "#", " ", "#", "#", "#", " ", "#"],
        ["#", " ", " ", " ", " ", " ", "#", " ", " ", " ", "#"],
        ["#", " ", "#", "#", "#", "#", "#", " ", "#", "#", "#"],
        ["#", " ", "#", " ", " ", " ", "#", " ", " ", " ", "@"],
        ["#", " ", "#", "#", "#", " ", "#", "#", "#", "#", "#"],
        ["#", " ", " ", " ", " ", " ", " ", " ", " ", " ", "#"],
        ["#", "#", "#", "#", "#", "#", "#", "#", "#", "#", "#"]
    ]

You can now refer to the start of the array as `0,3` in this matrix.

Mazes should be assumed to be bordered by blocking `#` tiles, creating an arena for the maze, however, that shouldn't actually change the BFS algorithm.

 
