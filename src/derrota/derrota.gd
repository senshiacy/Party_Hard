extends Control

var tree
var pontos: int = 0
@export var pontos_derrota: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var derrmenu = $VBoxContainer/DerrMenuButton
	tree = get_tree()
	
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func troca_pontos() -> void:
	pontos_derrota.text = "Pontuação: "+str(pontos)

func _on_derr_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/menu.tscn")
	queue_free()
