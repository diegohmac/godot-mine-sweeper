extends CanvasLayer

class_name UI

@onready var mine_count_label: Label = %MineCount
@onready var timer_label: Label = %Timer
@onready var game_status_button: TextureButton = %GameStatusButton

var game_over_button_texture = preload("res://assets/button_dead.png")
var game_won_button_texture = preload("res://assets/button_cleared.png")

func set_mine_count(mine_count: int):
	var mine_count_str = str(mine_count)
	if mine_count_str.length() < 3:
		mine_count_str = mine_count_str.lpad(3, "0")
	
	mine_count_label.text = mine_count_str
	
func set_timer(timer_count: int):
	var timer_count_str = str(timer_count)
	if timer_count_str.length() < 3:
		timer_count_str = timer_count_str.lpad(3, "0")
	
	timer_label.text = timer_count_str


func _on_game_status_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func game_over():
	game_status_button.texture_normal = game_over_button_texture
	
func game_won():
	game_status_button.texture_normal = game_won_button_texture
