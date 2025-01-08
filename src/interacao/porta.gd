extends Area2D

var aberta: bool = true
var mouse_na_porta: bool = false

@export var porta_fechada: Sprite2D = null
@export var porta_aberta: Sprite2D = null

var apertou: bool = false 

func _ready() -> void:
	chama_abre()
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and mouse_na_porta:
		if not aberta:
			chama_abre()
		else:
			chama_fecha()
		# aberta = not aberta

func chama_abre():
	apertou = true 

func chama_fecha():
	apertou = true

func abre():
	aberta = true
	porta_fechada.visible = false
	porta_aberta.visible = true

func fecha():
	aberta = false
	porta_fechada.visible = true
	porta_aberta.visible = false

func _on_mouse_entered() -> void:
	mouse_na_porta = true


func get_posicao_porta():
	return $No.global_position

func _on_mouse_exited() -> void:
	mouse_na_porta = false
