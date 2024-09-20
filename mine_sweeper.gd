extends Node2D

@export var ui: UI
@onready var timer: Timer = $Timer

const GRID_SIZE = 9
const NUM_MINES = 10
const CELL_SIZE = 32
const REVEALED_CELLS_COUNT_TO_WIN = GRID_SIZE * GRID_SIZE - NUM_MINES

var grid = []
var cells = []
var flags_placed = 0
var is_first_click = true
var time_elapsed = 0

var CellScene: PackedScene = preload("res://cell.tscn")

var grid_parent: Control # A node that will hold all the cells

func _ready():
	# Create a parent Node2D to hold the grid of cells
	grid_parent = Control.new()
	grid_parent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid_parent.set_size(Vector2(GRID_SIZE * CELL_SIZE, GRID_SIZE * CELL_SIZE))
	add_child(grid_parent)  # Add it to the main scene

	# Initialize the grid and populate the cells
	for i in range(GRID_SIZE):
		grid.append([])
		for j in range(GRID_SIZE):
			grid[i].append(0)

	print_grid()
	populateGrid()

	# Center the parent node after populating the grid
	center_grid()
	ui.set_mine_count(NUM_MINES)

func center_grid():
	# Get the viewport size
	var viewport_size = get_viewport().size

	# Use get_rect().size to get the size of grid_parent
	var grid_size = grid_parent.get_rect().size

	# Center the grid by setting the position
	grid_parent.set_position((Vector2(viewport_size) / 2) - (grid_size / 2))
	
func calculate_grid(x: int = -1, y: int = -1):
	if x != -1 and y != -1:
		print(x, y)
		place_mines(x, y)
		calculate_numbers()
		print_grid()
		populateGrid(x,y)
	
func populateGrid(x = -1, y = -1):
	clear_cells()  # Clear existing cells
	
	for i in range(GRID_SIZE):
		cells.append([])
		for j in range(GRID_SIZE):
			var cell = CellScene.instantiate()
			cells[i].append(cell)

			# Set the position of each cell
			cell.position = Vector2(i * CELL_SIZE, j * CELL_SIZE)
			cell.grid_position = Vector2(i, j)

			# Connect signals to handle clicks, mines, flags, etc.
			cell.connect("on_click", handle_first_click)
			cell.connect("mine_revealed", handle_game_over)
			cell.connect("cell_flagged", handle_flag_count)

			# Set specific properties for the cell based on the grid value
			var cellType = grid[i][j]
			if x == i and y == j:
				cell.is_revealed = true
			match cellType:
				-1:
					cell.is_mine = true
				1, 2, 3, 4, 5, 6, 7, 8:
					cell.adjacent_mines = cellType

			# Add the cell as a child of the parent node (grid_parent)
			grid_parent.add_child(cell)


func clear_cells():
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			if cells.size() > 0 and cells[i]:
				var cell = cells[i][j]
				if cell:
					cell.queue_free()
	cells.clear()

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
		
func handle_game_over():
	timer.stop()
	ui.game_over()
		
func check_win_condition():
	var revealed_cells_count = 0
	for i in range(GRID_SIZE):
		for j in range(GRID_SIZE):
			var cell = get_cell(i, j)
			if cell.is_revealed:
				revealed_cells_count += 1
	if revealed_cells_count == REVEALED_CELLS_COUNT_TO_WIN:
		timer.stop()
		ui.game_won()
		return

func handle_flag_count(grid_position, is_flagged: bool):
	if is_first_click:
		return
		
	if is_flagged:
		if flags_placed >= NUM_MINES:
			return
		else:
			flags_placed += 1
	else:
		flags_placed -= 1
		
	ui.set_mine_count(NUM_MINES - flags_placed)
	var cell = get_cell(grid_position.x, grid_position.y)
	cell.toggle_flag()

func _on_timer_timeout() -> void:
	time_elapsed += 1
	ui.set_timer(time_elapsed)
