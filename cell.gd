extends Node2D

## Signals to communicate with the main script
signal on_click(grid_position)
signal mine_revealed
signal cell_flagged(is_flagged)

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
	"exploded": preload("res://assets/TileExploded.png"),
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
	if is_revealed:
		update_texture()
	else:
		CellTexture.texture = textures["hidden"]
	
func reveal_cell():
	if is_revealed or is_flagged:
		return
	is_revealed = true
	update_texture()
	
	if is_mine:
		emit_signal("mine_revealed")
		pass
	else:
		#emit_signal("cell_revealed", grid_position)
		if adjacent_mines == 0:
			reveal_adjacent_cells()
	#
func update_texture():
	if is_mine:
		CellTexture.texture = textures["exploded"]
	elif adjacent_mines > 0:
		CellTexture.texture = textures["numbers"][adjacent_mines]
	else:
		CellTexture.texture = textures["revealed"]  # For cells with zero adjacent mines
#
func reveal_adjacent_cells():
	var game = get_parent().get_parent()
	for deltaX in range(-1, 2):
		for deltaY in range(-1, 2):
			if deltaX == 0 and deltaY == 0:
				continue  # Skip the current cell
			var newX = int(grid_position.x) + deltaX
			var newY = int(grid_position.y) + deltaY
			if game.is_valid_position(newX, newY):
				var neighbor_cell = game.get_cell(newX, newY)
				if neighbor_cell and not neighbor_cell.is_revealed and not neighbor_cell.is_flagged:
					neighbor_cell.reveal_cell()
#
func toggle_flag():
	if is_revealed:
		return
	is_flagged = not is_flagged
	if is_flagged:
		CellTexture.texture = textures["flag"]
	else:
		CellTexture.texture = textures["hidden"]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var game = get_parent().get_parent()
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("on_click", grid_position)
			reveal_cell()
			game.check_win_condition()
		elif event.button_index == MOUSE_BUTTON_RIGHT and not is_revealed:
			emit_signal("cell_flagged", grid_position, !is_flagged)
