extends CharacterBody2D
class_name Npc

@export var sprite_frames_lista: Array[SpriteFrames] = []
const VELOCIDADE = 300.0


var estado = EstadosNpc.PENSANDO

var local_interesse: Node2D
var conexoes
var fila

var cenario_atual: Node2D
var indice_sala_atual := 0
var cenarios 
## Caminho das portas para chegar na sala de interesse
var caminho: Array = []

@export var mapa: Map
 
var locais_interesse := [] #= [ Vector2(500, 500), Vector2(200, 200), Vector2(200, 200), Vector2(600, 200)]
var salas_das_posicoes_de_interesse := [ ]
var indice_local_interesse = -1

@export var assassino: bool = false # variavel para identificar o assasino  

var npc_alvo: Npc = null 
var salas 

var porcentagem_de_assasinato : float = 0.4
var tempo_de_espera: float = 4.0 


var ruido_posicao : float = 20
var ruido_velocidade: float = 30
var local_interesse_position: Vector2

var mouse_no_npc: bool = false

"""
func _ready():
	add_to_group("npc")
	conexoes = self.get_parent().get_parent().conexoes
	var cenarios = cenario_atual.get_parent()
	locais_interesse = cenarios.locais_de_interesse
	salas_das_posicoes_de_interesse = cenarios.salas_das_posicoes_de_interesse
"""

func _ready():
	$Sprite2D.sprite_frames = sprite_frames_lista.pick_random()
	add_to_group("npc")
	# conexoes = self.get_parent().get_parent().conexoes
	cenario_atual = self.get_parent()
	cenarios = cenario_atual.get_parent()
	locais_interesse = cenarios.get_locais_de_interesse()
	# print(locais_interesse)
	# print(locais_interesse)
	salas_das_posicoes_de_interesse = cenarios.salas_das_posicoes_de_interesse
	"""
	var matriz_caminho = mapa.get_matriz_caminho()
	var matriz_portas = mapa.get_matriz_portas()
	"""

func escolhe_alvo():
	# escolhendo alvo (assassino) 
	# var npcs_no_cenario = cenario_atual.get_children().filter(func (x) : return x is Npc and not x.assasino)
	var npcs = get_tree().get_nodes_in_group("npc").filter(func (x) : return not x.assassino) 
	if npcs.size() == 0: 
		return false
	npc_alvo = npcs.pick_random()
	indice_local_interesse = npc_alvo.indice_local_interesse
	local_interesse = npc_alvo.local_interesse 
	if (npc_alvo.indice_local_interesse < 0): return false
	return true 
	
func escolhe_local_interesse():
	indice_local_interesse = range(locais_interesse.size()).pick_random() # escolhe um indice aleatorio 
	local_interesse = locais_interesse[indice_local_interesse]  # escolhe um local de interesse do indice 
			
	
func _physics_process(delta: float) -> void:
	if estado == EstadosNpc.PENSANDO:
		
		if assassino: 
			var num_aleatorio = randf()
			if num_aleatorio <= porcentagem_de_assasinato:
				if escolhe_alvo() == false:
					escolhe_local_interesse()
				print(self, "npc alvo: ", npc_alvo)
			else:
				escolhe_local_interesse() 
			
		if not assassino: 
			escolhe_local_interesse()
		
		
		var ruido: = Vector2(randf_range(-ruido_posicao, ruido_posicao), randf_range(-ruido_posicao, ruido_posicao))
		local_interesse_position = local_interesse.position + ruido 	
		
		
		var sala_interesse = salas_das_posicoes_de_interesse[indice_local_interesse] # pega sala 
		# var posicao_interesse: Vector2 = locais_interesse[i].position # pega a posicao da sala 
		
		var sala_atual := indice_sala_atual 
		salas = [] # sequencia de salas no caminho 
		caminho = [] # sequencia de portas no caminho 
		
		while sala_atual != -2: # chegou na sala flag = -2  
			var proxima_sala = mapa.get_matriz_caminho()[sala_atual][sala_interesse] 
			if proxima_sala != -2: # chegou na ultima sala  
				salas.push_back(proxima_sala)
				caminho.push_back(mapa.get_matriz_portas()[sala_atual][proxima_sala])
			sala_atual = proxima_sala 
			
		
		print(str(get_path()), " Estou na sala ", indice_sala_atual, " e quero ir para ", " na sala ",
		 	sala_interesse, " passando pelas portas ", caminho, " das salas ", salas) 
			
		if caminho.size() > 0:
			estado = EstadosNpc.ANDANDOPORTA
		else:
			estado = EstadosNpc.ANDANDODESTINO
		
	elif estado == EstadosNpc.PARADO:
		#se não chegou em posicao_interesse, volta pra andando, e sai desse if
		
		estado = EstadosNpc.INTERESSADO
		$Sprite2D.play("idle")
		var espera = randf_range(0, tempo_de_espera)
		await get_tree().create_timer(espera).timeout # tempo interessado 
		estado = EstadosNpc.PENSANDO
		
	elif estado == EstadosNpc.ANDANDOPORTA:
		# move para uma porta 
		if caminho.size() > 0:
			var porta = caminho[0]
			var t = cenario_atual.get_child(4).get_child(porta)
			var pos = t.get_posicao_porta()

			var angulo = rad_to_deg(Vector2(self.position.x-pos.x, self.position.y-pos.y).angle())
			# print(angulo)
			if -135 <= angulo and angulo < -45:
				$Sprite2D.play("anda_pra_baixo")
			elif angulo <= -45 or angulo > 135:
				$Sprite2D.play("anda_pra_direita")
			elif 45 < angulo and angulo <= 135:
				$Sprite2D.play("anda_pra_cima")
			else:
				$Sprite2D.play("anda_pra_esquerda")
			var vel = VELOCIDADE + randf_range(-ruido_velocidade, ruido_velocidade)
			self.global_position = self.global_position.move_toward(pos, vel*delta)
			
			
			
			if self.global_position.is_equal_approx(pos):
				# print("Cheguei!")
				print("indice sala atual1: ", indice_sala_atual)
				var p = caminho.pop_front()
				if cenario_atual.get_child(4).get_child(p).aberta == false:
					estado = EstadosNpc.PENSANDO
					return
				indice_sala_atual = salas.pop_front()
				print("indice sala atual2: ", indice_sala_atual)
				self.estado = EstadosNpc.MUDANDOPORTA
		else:
			self.estado = EstadosNpc.ANDANDODESTINO	
				
		"""
		self.position = self.position.move_toward(local_interesse.position, VELOCIDADE*delta)
		if position == local_interesse.position:
			estado = EstadosNpc.PARADO
			#fazer coisa
		"""
	elif estado == EstadosNpc.ANDANDODESTINO:
		var angulo = rad_to_deg(Vector2(self.position.x-local_interesse.position.x, self.position.y-local_interesse.position.y).angle())
		# print(angulo)
		if -135 <= angulo and angulo < -45:
			$Sprite2D.play("anda_pra_baixo")
		elif angulo <= -45 or angulo > 135:
			$Sprite2D.play("anda_pra_direita")
		elif 45 < angulo and angulo <= 135:
			$Sprite2D.play("anda_pra_cima")
		else:
			$Sprite2D.play("anda_pra_esquerda")
		self.position = self.position.move_toward(local_interesse_position, VELOCIDADE*delta)
		if position.is_equal_approx(local_interesse_position):
			estado = EstadosNpc.PARADO
	
	elif estado == EstadosNpc.PERSEGUICAO:
		# entra no modo de perseguição 
		pass 
	
	elif estado == EstadosNpc.INTERESSADO:
		
		if assassino and npc_alvo != null and (npc_alvo.position - self.position).length() <= 2*ruido_posicao: # npc chegou na posição 
			npc_alvo.queue_free() # elimina o nó do npc  
			npc_alvo = null
	"""	
	elif estado == EstadosNpc.ESPERANDO:
		estado = EstadosNpc.ESPERANDODEFATO
		await get_tree().create_timer(tempo_espera_porta).timeout
		if estado == EstadosNpc.ESPERANDODEFATO:
			estado = EstadosNpc.PENSANDO
	"""
		
	
func bfs(filas, porta):
	var visitados = {}
	for x in conexoes:
		visitados[x] = false
	bfs_recursao(filas, porta, visitados)
	
	
func bfs_recursao(filas, porta, visitados):
	visitados[porta] = true
	var proxima_porta = conexoes[porta]
	if not visitados[proxima_porta]:
		bfs_recursao(filas, proxima_porta, visitados)
	fila.append(porta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and mouse_no_npc and cenarios.modo_de_jogo==1:
		get_viewport().set_input_as_handled()
		if not assassino:
			lose()
		else:
			win()
		
		
			
func lose() -> void:
	cenarios.incrementa_erro()
	
func win() -> void:
	cenarios.win()
	
func _on_area_2d_mouse_entered() -> void:
	mouse_no_npc = true

func _on_area_2d_mouse_exited() -> void:
	mouse_no_npc = false

		
#func bfs_recursao(fila, sala, visitados):
	#visitados[sala] = true
#
	#for porta in sala_tem_essas_portas:        # sala_tem_essas_portas = uma lista de portas da sala
		#proxima_porta = conexoes[porta]
		#proxima_sala = sala que está proxima_porta
#
		#if not visitados[proxima_sala]:
			#bfs_recursao(fila, proxima_sala, visitados)
			#fila.append(porta)
	
