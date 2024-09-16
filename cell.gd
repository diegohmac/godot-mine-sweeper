extends Node2D

# Signals to communicate with the main script
signal mine_triggered(position)
signal cell_revealed(position)

@onready var CellTexture: Sprite2D = get_node("CellTexture")

var grid_position = Vector2()
var is_revealed = false
var is_flagged = false
var is_mine = false
var adjacent_mines = 0

# Preload textures
var textures = {
	"hidden": preload("res://assets/TileUnknown.png"),
	"revealed": preload("res://assets/TileEmpty.png"),
	"flag": preload("res://assets/TileFlag.png"),
	"mine": preload("res://assets/TileMine.png"),
	"numbers": {
		1: preload("res://assets/Tile1.png"),
		2: preload("res://assets/Tile2.png"),
		3: preload("res://assets/Tile3.png"),
		4: preload("res://assets/Tile4.png"),
		5: preload("res://assets/Tile5.png"),
		6: preload("res://assets/Tile6.png"),
		7: preload("res://assets/Tile7.png"),
		8: preload("res://assets/Tile8.png"),
	}
}

func _ready() -> void:
	CellTexture.texture = textures["hidden"]
	
func reveal_cell():
	if is_revealed or is_flagged:
		return
	is_revealed = true
	update_texture()

	if is_mine:
		emit_signal("mine_triggered", grid_position)
		# Handle game over in main script
	else:
		emit_signal("cell_revealed", grid_position)
		if adjacent_mines == 0:
			# Recursively reveal adjacent cells
			reveal_adjacent_cells()

	# Disable input if necessary
	set_process_input(false)

func update_texture():
	if is_mine:
		CellTexture.texture = textures["mine"]
	elif adjacent_mines > 0:
		CellTexture.texture = textures["numbers"][adjacent_mines]
	else:
		CellTexture.texture = textures["revealed"]  # For cells with zero adjacent mines

func reveal_adjacent_cells():
	var game = get_parent()
	for deltaX in range(-1, 2):
		for deltaY in range(-1, 2):
			if deltaX == 0 and deltaY == 0:
				continue  # Skip the current cell
			var newX = int(grid_position.x) + deltaX
			var newY = int(grid_position.y) + deltaY
			if game.is_valid_position(newX, newY):
				var neighbor_cell = game.get_cell(newX, newY)
				if neighbor_cell and not neighbor_cell.is_revealed and not neighbor_cell.is_mine:
					neighbor_cell.reveal_cell()


func toggle_flag():
	if is_revealed:
		return
	is_flagged = not is_flagged
	if is_flagged:
		CellTexture.texture = textures["flag"]
	else:
		CellTexture.texture = textures["hidden"]
