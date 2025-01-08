extends Node2D

@export var mapa: Map
@export var cenarios: Array[Node2D] = []

@export var contador_erros: Label

var posicoes_cenarios: Array[Vector2] = []
var cenario_atual: int = 0
var conexoes
var portas_em_cenario
var locais_de_interesse := []
var salas_das_posicoes_de_interesse := []

var erros: int = 0

var modo_de_jogo: int = 0

var numero_npcs: int = 10

var num_cenarios: int = 3

var pontuacao: int = numero_npcs

# signal reparentou

func _ready() -> void:
	conexoes = {
		$Cenario1.get_child(4).get_child(0) : $Cenario2.get_child(4).get_child(0),
		$Cenario2.get_child(4).get_child(0) : $Cenario1.get_child(4).get_child(0),
		$Cenario2.get_child(4).get_child(1) : $Cenario3.get_child(4).get_child(0),
		$Cenario3.get_child(4).get_child(0) : $Cenario2.get_child(4).get_child(1)
	}
	"""
	usa a matriz_caminho e matriz_porta no lugar 
	portas_em_cenario = {
		$Cenario1.get_child(3).get_child(0) : $Cenario1,
		$Cenario2.get_child(3).get_child(0) : $Cenario2,
		$Cenario2.get_child(3).get_child(0) : $Cenario2,
		$Cenario3.get_child(3).get_child(0) : $Cenario3
	}
	"""
	
	var count = 0
	for cenario in cenarios:
		posicoes_cenarios.push_back(cenario.position)
		salas_das_posicoes_de_interesse.append_array(
			range(cenario.get_locais_de_interesse().size()).map(func(_x): return count)
		)
		locais_de_interesse.append_array(cenario.get_locais_de_interesse())
		count += 1
		
	var indice_aleatorio = range(num_cenarios).pick_random()
	var cenario_aleatorio = cenarios[indice_aleatorio]
	cenario_aleatorio.cria_npc(true, indice_aleatorio)
	
	for i in range(numero_npcs-1):
		indice_aleatorio = range(num_cenarios).pick_random()
		cenario_aleatorio = cenarios[indice_aleatorio]
		cenario_aleatorio.cria_npc(false, indice_aleatorio)
	# print(posicoes_cenarios)
	# print(locais_de_interesse)
	
func get_locais_de_interesse():
	return locais_de_interesse

func apertou_botao_esquerda():
	cenario_atual = (cenario_atual+posicoes_cenarios.size()-1)%posicoes_cenarios.size()
	$Camera2D.position = posicoes_cenarios[cenario_atual]
	
	
func apertou_botao_direita():
	cenario_atual = (cenario_atual+1)%posicoes_cenarios.size()
	$Camera2D.position = posicoes_cenarios[cenario_atual]
	

func _process(_delta):
	var npcs = get_tree().get_nodes_in_group("npc")
	
	pontuacao = npcs.size() - (erros*5)
	
	for conexao in conexoes.keys():
		if conexao.apertou:
			if conexao.aberta: 
				conexao.fecha() 
				conexoes[conexao].fecha()
			else:
				conexao.abre()
				conexoes[conexao].abre() 
			conexao.apertou = false
			
	
	for npc in npcs:
		for porta in conexoes.keys():
			if npc.global_position.is_equal_approx(porta.get_posicao_porta()) and (npc.estado==EstadosNpc.MUDANDOPORTA or npc.estado==EstadosNpc.ESPERANDODEFATO):
				if porta.aberta:
					npc.global_position = conexoes[porta].get_posicao_porta()
					npc.reparent(conexoes[porta].get_parent().get_parent())
					npc.cenario_atual = conexoes[porta].get_parent().get_parent() 
					print("mudou de cenário :", conexoes[porta].get_parent().get_parent().get_path())
					npc.estado = EstadosNpc.ANDANDOPORTA
				else:
					npc.estado = EstadosNpc.ESPERANDO
		
	
		
func incrementa_erro():
	erros += 1
	pontuacao -= 5
	contador_erros.text = "Erros: "+str(erros)+"/3"
	if erros == 3:
		cena_derrota()
		
func win():
	cena_vitoria()
		
func set_mode1():
	modo_de_jogo = 1
		
func set_mode2():
	modo_de_jogo = 2
	contador_erros.hide()


func _on_timer_timer_end() -> void:
	if modo_de_jogo == 1:
		cena_derrota()
	else:
		cena_gameover()
	
func cena_derrota():
	var derr = load("res://src/derrota/derrota.tscn").instantiate()
	get_tree().root.add_child(derr)
	derr.pontos = pontuacao
	derr.troca_pontos()
	queue_free()
	
func cena_vitoria():
	var vit = load("res://src/vitoria/vitoria.tscn").instantiate()
	get_tree().root.add_child(vit)
	vit.pontos = pontuacao
	vit.troca_pontos()
	vit.win()
	queue_free()
	
func cena_gameover():
	var gameover = load("res://src/vitoria/vitoria.tscn").instantiate()
	get_tree().root.add_child(gameover)
	gameover.pontos = pontuacao
	gameover.troca_pontos()
	gameover.gameover()
	queue_free()
