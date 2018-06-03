maze_map = %Q(
--------------------
-              -   -
-  -   ---  -  - - -
-  -   -   --- - - -
-  - A -   - - - - -
-  -   -B          -
-- -   --          -
-                  -
--------------------
)

sample_path = %i(down   down   down  right
                 right  right  right right
                 right  right  up
                 up     right  right  up
                 up     up     up    left
                 left   left   left  down
                 down   down   down  left
                 left)

class Maze
  OK = 0
  WALL = 1
  START = 2
  TARGET = 3

  def initialize(maze_map)
    @maze = parse_maze(maze_map)
    @start_row, @start_column = *find_value(@maze, START)
    restart
  end

  # Restart the maze travel by bringing you back to the starting point.
  def restart
    @current_row, @current_column = @start_row, @start_column
    true
  end

  # Move up the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def up
    move(-1, 0)
  end

  # Move down the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def down
    move(1, 0)
  end

  # Move left in the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def left
    move(0, -1)
  end

  # Move right in the maze. Returns OK if you've made a move, WALL if you
  # hit the wall and TARGET if you've reached your destination.
  def right
    move(0, 1)
  end

  # Print the maze to the console.
  def print(clear_screen=false)
    cls if clear_screen
    @maze.each_with_index do |row, index|
      line = row.
          join('').
          gsub(OK.to_s, ' ').
          gsub(START.to_s, 'A').
          gsub(TARGET.to_s, 'B').
          gsub(WALL.to_s, '-')
      if index == @current_row
        line[@current_column] = '*'
      end
      puts line
    end
    nil
  end

  # Current point of the maze. Either START, or OK, or TARGET.
  def current_point
    @maze[@current_row][@current_column]
  end

  # Inspect the maze object without revealing its actual contents.
  def inspect
    "#<Maze:#{object_id}>"
  end

  # Verifies the path in the form of a directions array. If the
  # directions lead to the target, exits without exceptions. If not
  # the corresponding exception gets raised.
  def verify_path!(path)
    maze = self.dup
    maze.restart
    maze.print(true)
    path.each do |step|
      sleep(0.15)
      if maze.send(step) == WALL
        raise "You've hit a wall. Sorry."
      end
      maze.print(true)
    end
    unless maze.current_point == TARGET
      raise "You have never found your target. Sorry."
    end
  end

  private

  def move(d_row, d_column)
    return TARGET if current_point == TARGET

    target_value = @maze[@current_row + d_row][@current_column + d_column]
    if target_value != WALL
      @current_row += d_row
      @current_column += d_column
      if target_value != TARGET
        target_value = OK
      end
    end

    target_value
  end

  def find_value(array, value)
    y = array.index { |row| row.include?(value) }
    [ y, array[y].index(value) ]
  end

  def parse_maze(maze_map)
    maze_map.
        strip.
        split("\n").
        map { |row|
          row.
              gsub(/-/, WALL.to_s).
              gsub(' ', OK.to_s).
              gsub('A', START.to_s).
              gsub('B', TARGET.to_s).
              split(//).
              map(&:to_i).
              freeze
        }.freeze
  end

  def cls
    puts "\e[H\e[2J"
  end
end

maze = Maze.new(maze_map)

# code here
# class for search path to target into labyrinth
class SymbolPath

  ROUTE = %i[down left up right].freeze
  OPTION = { down: [1, 0], left: [0, -1], up: [-1, 0], right: [0, 1] }.freeze

  def initialize(maze_map)
    @maze = parse_maze(maze_map)
    @sample_path = []
  end

  def find_path
    filling_maze
    write_path
  end

  private

  # record the path from the zero point to the target
  def write_path
    current = find_target('B')[0]
    target = find_target(0)[0]
    sequent = nil
    key = nil
    sample_path = []
    loop do
      ROUTE.each_with_index do |direction, index|
        cell = value_at(current, direction)
        next if cell.class == String || cell.nil?
        if (sequent || (cell + 1)) > cell
          sequent = cell
          key = index
        end
      end
      current = [current[0] + OPTION[ROUTE[key]][0],
                 current[1] + OPTION[ROUTE[key]][1]]
      sample_path << ROUTE[(key + 2) % 4]
      break if current == target
    end
    sample_path.reverse
  end

  # fills the labyrinth the distance from the zero point
  def filling_maze
    distance = 0
    stop = nil
    loop do
      find_target(distance).each do |index|
        ROUTE.each do |direction|
          stop = true unless move(index, direction, distance + 1)
        end
      end
      break if stop
      distance += 1
    end
  end

  # return content of cell in the double array
  def value_at(index, direction)
    @maze[index[0] + OPTION[direction][0]][index[1] + OPTION[direction][1]]
  end

  # write to cell in the double array
  def write_to_cell(index, direction, content)
    @maze[index[0] + OPTION[direction][0]][index[1] + OPTION[direction][1]] = content
  end

  # checks the content of neighbor cell and records the distance there
  # return nil if the moves ended
  def move(index, direction, distance)
    cell = value_at(index, direction)
    write_to_cell(index, direction, distance) if cell.nil?
    return nil if cell == 'B'
    distance
  end

  def find_target(target)
    array = []
    @maze.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        array << [row_index, cell_index] if target == cell
      end
    end
    array
  end

  def parse_maze(maze_map)
    maze_map.strip.split("\n").map do |row|
      row.split(//).map do |value|
        if value == 'A'
          0
        elsif value == ' '
          nil
        else
          value
        end
      end
    end
  end
end

path = SymbolPath.new(maze_map)

solution = path.find_path
maze.verify_path!(solution)
puts "Congratulations! Looks like you've found your way out!"