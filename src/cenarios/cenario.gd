extends Node2D
class_name Cenario

@export var posicao_porta: Node2D = null
@export var cena_npc: PackedScene
@onready var posicoes_de_interesse: Node2D = $PosicoesInteresse

signal npc_saiu(npc: Npc)

var tem_npc = false
var ruido: float = 12.5 

func _process(_delta: float) -> void:
	# var numero_aleatorio = randf()
	
	if not tem_npc:
		# cria_npc()
		tem_npc = true
	
func cria_npc(assasino, sala_atual):
	var npc: Npc = cena_npc.instantiate() 
#	var porta_position: Vector2 = posicao_porta.position
#	npc.position = porta_position + Vector2(10, 10)
	var posicao_aleatoria : Vector2 = get_locais_de_interesse().pick_random().position
	posicao_aleatoria += Vector2(randf_range(-ruido, ruido), randf_range(-ruido, ruido))
	npc.position = posicao_aleatoria
	npc.cenario_atual = self
	if (assasino): npc.assassino = true
	npc.indice_sala_atual = sala_atual
	self.add_child(npc)

func get_locais_de_interesse() -> Array:
	return posicoes_de_interesse.get_children()

func remove_npc(npc: Node2D):
	npc.queue_free()
