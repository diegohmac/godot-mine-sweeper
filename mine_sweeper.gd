extends Node2D

const GRID_SIZE = 9
const NUM_MINES = 10

# The grid will be a list of lists
var grid = []

func _ready():
	print(randi())
	print(randi() % GRID_SIZE)
	randomize()
	# Initialize the 9x9 grid with zeros
	for i in range(GRID_SIZE):
		grid.append([])
		for j in range(GRID_SIZE):
			grid[i].append(0)
	# Place the Mines			
	place_mines()
	calculate_numbers()
	print_grid()

func place_mines():
	var minesPlaced = 0
	while minesPlaced < NUM_MINES:
		var x = randi() % GRID_SIZE
		var y = randi() % GRID_SIZE
		# Check if a mine is already placed at this position
		if grid[x][y] != -1:
			grid[x][y] = -1  # Use -1 to represent a mine
			minesPlaced += 1

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
