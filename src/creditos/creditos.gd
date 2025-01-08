extends Control

var tree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var menu = $Return
	tree = get_tree()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	var menu = load("res://src/menu/menu.tscn").instantiate()
	add_sibling(menu)
	queue_free()
