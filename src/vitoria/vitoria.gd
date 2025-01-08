extends Control

var tree
var pontos: int = 0
@export var venceu: Label
@export var pontos_vitoria: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = $VBoxContainer/VitMenuButton
	tree = get_tree()
	pontos_vitoria.text = "Pontuação: "+str(pontos)
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func gameover() -> void:
	venceu.text = "FIM DE JOGO!"

func win() -> void:
	venceu.text = "VOCÊ VENCEU!"

func troca_pontos() -> void:
	pontos_vitoria.text = "Pontuação: "+str(pontos)

func _on_vit_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/menu/menu.tscn")
	queue_free()
