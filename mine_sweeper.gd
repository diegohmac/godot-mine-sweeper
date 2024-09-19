extends Node2D

const GRID_SIZE = 9
const NUM_MINES = 10
const CELL_SIZE = 32

var grid = []
var cells = []
var is_first_click = true

var CellScene: PackedScene = preload("res://cell.tscn")

func _ready():
	# Initialize the 9x9 grid with zeros
	for i in range(GRID_SIZE):
		grid.append([])
		for j in range(GRID_SIZE):
			grid[i].append(0)

	print_grid()
	populateGrid()
	
func calculate_grid(x: int = -1, y: int = -1):
	if x != -1 and y != -1:
		print(x, y)
		place_mines(x, y)
		calculate_numbers()
		print_grid()
		#populateGrid()
	
func populateGrid():
	cells.clear()
	for i in grid.size():
		cells.append([])
		for j in grid[i].size():
			var cellType = grid[i][j]
			var cell = CellScene.instantiate()
			cells[i].append(cell)
			cell.position = Vector2(i * CELL_SIZE, j * CELL_SIZE)
			cell.grid_position = Vector2(i, j)
			cell.connect("on_click", handle_first_click)
			
			match cellType:
				-1:
					cell.is_mine = true
				1, 2, 3, 4, 5, 6, 7, 8:
					cell.adjacent_mines = cellType
			
			add_child(cell)

func place_mines(exclude_x: int, exclude_y: int):
	var minesPlaced = 0
	while minesPlaced < NUM_MINES:
		var mine_x = randi() % GRID_SIZE
		var mine_y = randi() % GRID_SIZE

		# If exclude_x and exclude_y are -1, place mines without restrictions
		if exclude_x == -1 or exclude_y == -1:
			if grid[mine_x][mine_y] != -1:
				grid[mine_x][mine_y] = -1  # Place the mine
				minesPlaced += 1
		# Otherwise, check for exclusion zone
		elif grid[mine_x][mine_y] != -1 and not is_adjacent_or_equal(mine_x, mine_y, exclude_x, exclude_y):
			grid[mine_x][mine_y] = -1  # Place the mine
			minesPlaced += 1

# Helper function to check if (mine_x, mine_y) is adjacent or equal to (exclude_x, exclude_y)
func is_adjacent_or_equal(mine_x: int, mine_y: int, exclude_x: int, exclude_y: int) -> bool:
	return abs(mine_x - exclude_x) <= 1 and abs(mine_y - exclude_y) <= 1

func calculate_numbers():
	for x in range(GRID_SIZE):
		for y in range(GRID_SIZE):
			if grid[x][y] == -1:
				continue  # Skip mines
			var mine_count = 0
			# Loop through adjacent cells
			for i in range(-1, 2):
				for j in range(-1, 2):
					if i == 0 and j == 0:
						continue  # Skip the current cell
					var nx = x + i
					var ny = y + j
					# Check if nx and ny are within grid boundaries
					if nx >= 0 and nx < GRID_SIZE and ny >= 0 and ny < GRID_SIZE:
						if grid[nx][ny] == -1:
							mine_count += 1
			grid[x][y] = mine_count
			
func print_grid():
	for y in range(GRID_SIZE):
		var row = ""
		for x in range(GRID_SIZE):
			var cell = grid[x][y]
			if cell == -1:
				row += "* "  # Represent mines with an asterisk
			else:
				row += str(cell) + " "
		print(row)
		
func is_valid_position(x, y):
	return x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE
		
func get_cell(x: int, y: int):
	if is_valid_position(x, y):
		return cells[x][y]

func handle_first_click(grid_position):
	if is_first_click:
		is_first_click = false
		calculate_grid(grid_position.x, grid_position.y)
