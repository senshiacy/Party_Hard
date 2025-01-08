extends Control

@export var cenarios : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr = get_tree().get_nodes_in_group("npc")
	$Label.text = str(arr.size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var arr = get_tree().get_nodes_in_group("npc")
	$Label.text = str(arr.size())
