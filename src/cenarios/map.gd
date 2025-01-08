extends Resource
class_name Map

@export var cenas_das_salas: Array[PackedScene] = []

@export_multiline var json_mapa: String


## Matriz que representa a próxima sala para chegar na sala j a partir da posição i
func get_matriz_caminho() -> Array:
	return JSON.parse_string(json_mapa)["matriz_caminho"]
## Matriz que representa a porta para chegar na sala j a partir da posição i
func get_matriz_portas() -> Array:
	return JSON.parse_string(json_mapa)["matriz_portas"]
