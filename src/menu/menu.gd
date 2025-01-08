extends Control

var tree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_game = $VBoxContainer/StartGameButton
	var start_game2 = $VBoxContainer/StartGameButton2
	var options = $VBoxContainer/OptionsButton
	var endcredits = $VBoxContainer/EndCreditsButton
	tree = get_tree()
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_start_game_button_pressed() -> void:
	var cenarios = load("res://src/cenarios/cenarios.tscn").instantiate()
	add_sibling(cenarios)
	cenarios.set_mode1()
	queue_free()


func _on_start_game_button_2_pressed() -> void:
	var cenarios = load("res://src/cenarios/cenarios.tscn").instantiate()
	add_sibling(cenarios)
	cenarios.set_mode2()
	queue_free()



func _on_end_credits_button_pressed() -> void:
	var creditos = load("res://src/creditos/creditos.tscn").instantiate()
	add_sibling(creditos)
	queue_free()
