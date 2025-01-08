extends Control
@export var timer : Timer
@export var ponteiro_min : Sprite2D
@export var ponteiro_seg : Sprite2D
signal timer_end
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pass # Replace with function body.
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	ponteiro_seg.set_rotation(((timer.time_left - timer.time_left / 60) * (2 * PI))/60)
	ponteiro_min.set_rotation(((timer.time_left / 60) * (2 * PI))/ 60)


func _on_timer_timeout() -> void:
	#pass # Replace with function body.
	#get_tree().change_scene_to_file("res://src/menu/menu.tscn")
	
	timer_end.emit()
