extends Node2D

"""general"""
var monedas_demonio = 5
var ruleta_girada = false
var poder_girar = true
var apuesta
var fase_eleccion = true
var jugador_ganador
var escapar = false

var posiciones_inventario = [Vector2(-778,-218),Vector2(-778,-73),Vector2(-778,71),Vector2(-778,215)]
var objeto_inventario = [[false,false,false,false],[false,false,false,false],[false,false,false,false],[false,false,false,false]]
var mouse_area = [false,false,false,false]
var posicion_actual = [posiciones_inventario[0],posiciones_inventario[1],posiciones_inventario[2],posiciones_inventario[3]]
var intercambio = false

var una_vez = [true,true,true,true]
var ruleta_apuestas = false
var si_color = false
var timer_efectos = true
var inicio = 0

"""habilidades"""
var instancia_habilidad = preload("res://scenes/habilidades.tscn")
var una_vez_habilidades = []
var habilidades = []
var enemigo
var inicio_habilidades = 0
var posiciones_habilidades = [Vector2(805,-298),Vector2(805,-198),Vector2(805,-98)]

"""habilidades_rojo"""
var casillas_azules_habilidad = []
var orden_azules_habilidad = []

"""efectos de estado"""
var activacion_estado = false

"""azul/rojo"""
var color_elegido
var colores_verdaderos = ["rojo","azul","azul","rojo","rojo","azul","azul","rojo","rojo","azul","azul","rojo"]
var color_verdadero = ""

"""rojo"""
var casilla_azul_elegida = null
var orden_casilla_azul
@onready var  casillas_azules = [$Sprite2D/casilla2D,$Sprite2D/casilla2D2,$Sprite2D/casilla2D5,$Sprite2D/casilla2D6,$Sprite2D/casilla2D9,$Sprite2D/casilla2D10]
var orden_casillas_azules = [2,1,10,9,6,5]
@onready var casillas_azules_original = [$Sprite2D/casilla2D,$Sprite2D/casilla2D2,$Sprite2D/casilla2D5,$Sprite2D/casilla2D6,$Sprite2D/casilla2D9,$Sprite2D/casilla2D10]
var orden_casillas_azules_original = [2,1,10,9,6,5]
var orden_casillas_azules_modificadas = [null,null,null,null]
var casillas_azules_modificadas = [null,null,null,null]

"""azul"""
var casilla_roja_elegida = null
var orden_casilla_roja
@onready var casillas_rojas = [$Sprite2D/CasillaRoja,$Sprite2D/casilla2D3,$Sprite2D/casilla2D4,$Sprite2D/casilla2D7,$Sprite2D/casilla2D8,$Sprite2D/casilla2D11]
var orden_casillas_rojas = [3,0,11,8,7,4]
@onready var casillas_rojas_original = [$Sprite2D/CasillaRoja,$Sprite2D/casilla2D3,$Sprite2D/casilla2D4,$Sprite2D/casilla2D7,$Sprite2D/casilla2D8,$Sprite2D/casilla2D11]
var orden_casillas_rojas_original = [3,0,11,8,7,4]
var orden_casillas_rojas_modificadas = [null,null,null,null]
var casillas_rojas_modificadas = [null,null,null,null]

"""candado_cerrado"""
var habilidad_identificada

func _ready() -> void:
	
	"""mosquito"""
	enemigo = "mosquito"
	for h in range(3):
		habilidades.append(instancia_habilidad.instantiate())
		una_vez_habilidades.append(true)
		casillas_azules_habilidad.append(null)
		orden_azules_habilidad.append(null)
		
	habilidades[0].add_to_group("habilidades")
	habilidades[0].get_node("habilidad").texture = preload("res://sprites/sed_de_sangre.png")
	habilidades[0].position = posiciones_habilidades[0]
	habilidades[0].get_node("habilidad").scale = Vector2(0.18,0.18)
	habilidades[0].get_node("Label6").text = "Toda vez que la ruleta caiga\nen una casilla roja, este enemigo\ngana en el proximo turno 1$ y tu -1$."
	habilidades[0].get_node("habilidad").rotation = -6.9
	add_child(habilidades[0])
	
	habilidades[1].add_to_group("habilidades")
	habilidades[1].get_node("habilidad").texture = preload("res://sprites/rosa_roja.png")
	habilidades[1].position = posiciones_habilidades[1]
	habilidades[1].get_node("habilidad").scale = Vector2(0.1,0.1)
	habilidades[1].get_node("Label6").text = "Cambia una casilla\naleatoria al rojo\nal principio del combate."
	habilidades[1].get_node("habilidad").rotation = 0.0
	add_child(habilidades[1])
	
	habilidades[2].add_to_group("habilidades")
	habilidades[2].get_node("habilidad").texture = preload("res://sprites/rosa_roja.png")
	habilidades[2].position = posiciones_habilidades[2]
	habilidades[2].get_node("habilidad").scale = Vector2(0.1,0.1)
	habilidades[2].get_node("Label6").text = "Cambia una casilla\naleatoria al rojo\nal principio del combate."
	habilidades[2].get_node("habilidad").rotation = 0.0
	add_child(habilidades[2])
	
	$AnimationPlayer.play("movimiento_mosquito")
	
	"""Items para hacer pruebas"""
	
	Global.item[0].add_to_group("items")
	Global.item[0].position = posiciones_inventario[0]
	Global.item[0].get_node("Sprite2D").texture = preload("res://sprites/rosa_roja.png")
	Global.item[0].get_node("Sprite2D").scale = Vector2(0.15,0.15)
	Global.item[0].get_node("CollisionShape2D").shape.size = Vector2(117,90)
	Global.item[0].get_node("Label").text = "Cambia una casilla\naleatoria al rojo\nal principio del combate."
	add_child(Global.item[0])
	
	Global.item[1].add_to_group("items")                                                                                                                                                                                                                 
	Global.item[1].position = posiciones_inventario[1]
	Global.item[1].get_node("Sprite2D").texture = preload("res://sprites/rosa_azul.png")
	Global.item[1].get_node("Sprite2D").scale = Vector2(0.15,0.15)
	Global.item[1].get_node("CollisionShape2D").shape.size = Vector2(117,90)
	Global.item[1].get_node("Label").text = "Cambia una casilla\naleatoria al azul\nal principio del combate."
	add_child(Global.item[1])
	
	Global.item[2].add_to_group("items")
	Global.item[2].position = posiciones_inventario[2]
	Global.item[2].get_node("Sprite2D").texture = preload("res://sprites/boton_reinicio.png")
	Global.item[2].get_node("Sprite2D").scale = Vector2(0.5,0.45)
	Global.item[2].get_node("CollisionShape2D").shape.size = Vector2(66,115)
	Global.item[2].get_node("Label").text = "Toda vez que el jugador no pueda elegir,\nla ruleta vuelve a su estado normal durante 1 turno"
	add_child(Global.item[2])
	
	Global.item[3].add_to_group("items")
	Global.item[3].position = posiciones_inventario[3]
	Global.item[3].get_node("Sprite2D").texture = preload("res://sprites/candado.png")
	Global.item[3].get_node("Sprite2D").scale = Vector2(0.3,0.3)
	Global.item[3].get_node("CollisionShape2D").shape.size = Vector2(69,92)
	Global.item[3].get_node("Label").text = "Anula una habilidad cualquiera\ndel oponente cada turno."
	add_child(Global.item[3])
	
	"""Dinero del jugador y del enemigo"""
	RenderingServer.set_default_clear_color(Color(0.25, 0.25, 0.25))
	randomize()
	if monedas_demonio <= Global.dinero:
		apuesta = randi_range(1,monedas_demonio)
	else:
		apuesta = randi_range(1,Global.dinero)
	$Label3.text = "APUESTA: ?"
	$Label2.text = str(Global.dinero) + "$"
	$Label5.text = str(monedas_demonio) + "$"
	

	
func girar_sprite():                                                                                                                                                                             
	ruleta_girada = true                                  
	var tween = create_tween()
	var valor = randi_range(1080, 1440)                                                                                
	tween.tween_property(
		$Sprite2D,
		"rotation",                                                          
		$Sprite2D.rotation + deg_to_rad(valor),
		2.0
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_button_pressed() -> void:
	if not Global.efectos:
		$Button.visible = false
		$Button2.visible = false
		if poder_girar:
			girar_sprite()

func _process(delta):
	
	"""Efectos de estado"""
	if color_verdadero == "rojo" and activacion_estado and enemigo == "mosquito":
		$MarcadoEfectoEstado.visible = true
		$efecto_estado.visible = true
	
	"""mosquito"""
	if monedas_demonio == 0:
		$Mosquito.visible = false
		$Mosquito2.visible = true
		
	"""Efectos items"""
	if ruleta_apuestas and timer_efectos:
		for p in range(inicio,posiciones_inventario.size()):
			for i in range(Global.item.size()):
				if Global.item[i].position == posiciones_inventario[p] and timer_efectos:
					if p == 0:
						$Inventario/Marcado4.visible = true
					elif p == 1:
						$Inventario/Marcado3.visible = true
					elif p == 2:
						$Inventario/Marcado2.visible = true
					else:
						$Inventario/Marcado.visible = true
					"""rosa_roja"""
					if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/rosa_roja.png"):
						if una_vez[i]:
							Global.item[i].get_node("rosa_roja").emitting = true
							casilla_azul_elegida = casillas_azules.pick_random()
							while casilla_azul_elegida == null:
								casilla_azul_elegida = casillas_azules.pick_random()
							orden_casilla_azul = orden_casillas_azules[casillas_azules.find(casilla_azul_elegida)]
							Global.item[i].get_node("rosa_roja2").reparent(casilla_azul_elegida)
							Global.item[i].get_node("rosa_azul2").reparent(casilla_azul_elegida)
							casilla_azul_elegida.get_node("rosa_roja2").position = 	Vector2(0,0)
							casilla_azul_elegida.get_node("rosa_azul2").position = Vector2(0,0)
							casilla_azul_elegida.get_node("rosa_roja2").emitting = true
			
							"""eliminar las casillas azules de las listas y agregarlas a nuevas listas"""
							casillas_azules[casillas_azules.find(casilla_azul_elegida)] = null
							orden_casillas_azules[orden_casillas_azules.find(orden_casilla_azul)] = null
							casillas_azules_modificadas[i] = casilla_azul_elegida
							orden_casillas_azules_modificadas[i] = orden_casilla_azul
						
			
					"""rosa_azul"""
					if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/rosa_azul.png"):
						if una_vez[i]:
							Global.item[i].get_node("rosa_azul").emitting = true
							casilla_roja_elegida = casillas_rojas.pick_random()
							while casilla_roja_elegida == null:
								casilla_roja_elegida = casillas_rojas.pick_random()
							orden_casilla_roja = orden_casillas_rojas[casillas_rojas.find(casilla_roja_elegida)]
							Global.item[i].get_node("rosa_azul2").reparent(casilla_roja_elegida)
							Global.item[i].get_node("rosa_roja2").reparent(casilla_roja_elegida)
							casilla_roja_elegida.get_node("rosa_azul2").position = Vector2(0,0)
							casilla_roja_elegida.get_node("rosa_roja2").position = Vector2(0,0)
							casilla_roja_elegida.get_node("rosa_azul2").emitting = true
			
							"""eliminar las casillas rojas de las listas y agregarlas a nuevas listas"""
							casillas_rojas[casillas_rojas.find(casilla_roja_elegida)] = null
							orden_casillas_rojas[orden_casillas_rojas.find(orden_casilla_roja)] = null
							casillas_rojas_modificadas[i] = casilla_roja_elegida
							orden_casillas_rojas_modificadas[i] = orden_casilla_roja
						
					"""candado_cerrado"""
					if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/candado.png"):
						habilidad_identificada = habilidades.pick_random()
						Global.item[i].get_node("candado_cerrado").emitting = true
						habilidad_identificada.get_node("candado_cerrado2").emitting = true
						
					"""boton_reinicio"""
					if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/boton_reinicio.png"):
						if not jugador_ganador:
							for ca in range(casillas_azules.size()):
								for cao in range(casillas_azules_original.size()):
									if ca == cao and casillas_azules[ca] != casillas_azules_original[cao]:
										if casillas_azules_original[cao].has_node("rosa_azul2"):
											casillas_azules_original[cao].get_node("rosa_azul2").emitting = true
										else:
											casillas_azules_original[cao].get_node("rosa_azul2_habilidades").emitting = true
										Global.item[i].get_node("boton_reinicio").emitting = true
							for cr in range(casillas_rojas.size()):
								for cro in range(casillas_rojas_original.size()):
									if cr == cro and casillas_rojas[cr] != casillas_rojas_original[cro]:
										casillas_rojas_original[cro].get_node("rosa_roja2").emitting = true
										Global.item[i].get_node("boton_reinicio").emitting = true
						else:
							for ca in range(casillas_azules.size()):
								if casillas_azules[ca] != null:
									for it in range(Global.item.size()):
										if casillas_azules_modificadas[it] == casillas_azules_original[ca]:
											Global.item[i].get_node("boton_reinicio").emitting = true
											casillas_azules_modificadas[it].get_node("rosa_roja2").emitting = true
									for h in range(habilidades.size()):
										if casillas_azules_habilidad[h] == casillas_azules_original[ca]:
											Global.item[i].get_node("boton_reinicio").emitting = true
											casillas_azules_habilidad[h].get_node("rosa_roja2_habilidades").emitting = true
											
							for cr in range(casillas_rojas.size()):
								if casillas_rojas[cr] != null:
									for it in range(Global.item.size()):
										if casillas_rojas_modificadas[it] == casillas_rojas_original[cr]:
											casillas_rojas_modificadas[it].get_node("rosa_azul2").emitting = true
											Global.item[i].get_node("boton_reinicio").emitting = true
											
										
					$tiempo_efectos.start()
					Global.efectos = true
					timer_efectos = false
		
		"""habilidades"""
		if timer_efectos:
			for c in range(inicio_habilidades,habilidades.size()):
				for h in range(habilidades.size()):
					if habilidades[h].position == posiciones_habilidades[c] and timer_efectos:
						"""sed_de_sangre"""
						if habilidades[h].get_node("habilidad").texture == preload("res://sprites/sed_de_sangre.png"):
							if habilidad_identificada == habilidades[h]:
								for i in range(Global.item.size()):
									if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/candado.png"):
										Global.item[i].get_node("candado_cerrado").emitting = false
								habilidad_identificada.get_node("candado_cerrado2").emitting = false
								$MarcadoEfectoEstado.visible = false
								$efecto_estado.visible = false
								activacion_estado = false
							else:
								habilidades[h].get_node("MarcadoHabilidades/marcado").visible = true
								activacion_estado = false
								if color_verdadero == "rojo":
									habilidades[h].get_node("rosa_roja_habilidades").emitting = true
									$MarcadoEfectoEstado.visible = false
									$efecto_estado.visible = false
									Global.dinero -= 1
									monedas_demonio += 1
									$Label2.text = str(Global.dinero)+"$"
									$Label5.text = str(monedas_demonio)+"$"
						
						"""rosa_roja"""
						if habilidades[h].get_node("habilidad").texture == preload("res://sprites/rosa_roja.png"):
							habilidades[h].get_node("MarcadoHabilidades/marcado").visible = true
							if habilidad_identificada == habilidades[h]:
								for i in range(Global.item.size()):
									if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/candado.png"):
										Global.item[i].get_node("candado_cerrado").emitting = false
								habilidad_identificada.get_node("candado_cerrado2").emitting = false
							else:
								if una_vez_habilidades[h]:
									habilidades[h].get_node("rosa_roja_habilidades").emitting = true
									activacion_estado = false
									casilla_azul_elegida = casillas_azules.pick_random()
									while casilla_azul_elegida == null:
										casilla_azul_elegida = casillas_azules.pick_random()
									orden_casilla_azul = orden_casillas_azules[casillas_azules.find(casilla_azul_elegida)]
									habilidades[h].get_node("rosa_roja2_habilidades").reparent(casilla_azul_elegida)
									habilidades[h].get_node("rosa_azul2_habilidades").reparent(casilla_azul_elegida)
									casilla_azul_elegida.get_node("rosa_roja2_habilidades").position = 	Vector2(0,0)
									casilla_azul_elegida.get_node("rosa_azul2_habilidades").position = 	Vector2(0,0)
									casilla_azul_elegida.get_node("rosa_roja2_habilidades").emitting = true
					
					
									"""eliminar las casillas azules de las listas y agregarlas a nuevas listas"""
									casillas_azules[casillas_azules.find(casilla_azul_elegida)] = null
									orden_casillas_azules[orden_casillas_azules.find(orden_casilla_azul)] = null
									casillas_azules_habilidad[h] = casilla_azul_elegida
									orden_azules_habilidad[h] = orden_casilla_azul
								
				
						$tiempo_efectos.start()
						Global.efectos = true
						timer_efectos = false
						#if h == habilidades.size()-1:
							#ruleta_apuestas = false
	
	"""elegir apuesta"""
	if not Global.efectos and ruleta_apuestas:
		ruleta_apuestas = false
		if monedas_demonio <= Global.dinero:
			apuesta = randi_range(1,monedas_demonio)
		else:
			apuesta = randi_range(1,Global.dinero)
		$Label3.text = "APUESTA: "+ str(apuesta) +"$"
	
	"""RULETA ELECCION"""
	if ruleta_girada and fase_eleccion:
		fase_eleccion = false
		ruleta_girada = false
		$Timer2.start()
		$Timer3.start()
	
	"""RULETA DE APUESTAS"""
	if ruleta_girada and not fase_eleccion:
		ruleta_girada = false
		fase_eleccion = true
		$Timer.start()
		$Label4.visible = false
		$Timer3.start()
		
	
	"""INVENTARIO"""
	var posicion_anterior = [posicion_actual[0],posicion_actual[1],posicion_actual[2],posicion_actual[3]]
	
	"""hacer invisibles las descripciones"""
	for it in range(Global.item.size()):
		if Global.arrastrando[it]:
			Global.item[it].get_node("Label").visible = false
	
	"""posiciones"""
	for objeto_inv in range(objeto_inventario.size()):
		for objeto in range(objeto_inventario[0].size()):
			if objeto_inventario[objeto_inv][objeto_inventario[0].size()-objeto-1]:
				if not Global.arrastrando[objeto_inv] and mouse_area[objeto] and not intercambio:
					Global.item[objeto_inv].position = posiciones_inventario[posiciones_inventario.size()-1-objeto]
					posicion_actual[objeto_inv] = Global.item[objeto_inv].position
		
	"""NO salir del inventario"""
	var dentro = [false,false,false,false]
	for espacio in posiciones_inventario:
		for it in range(Global.item.size()):
			if espacio == Global.item[it].position:
				dentro[it] = true
	
	for den in range(dentro.size()):
		if not dentro[den] and not Global.arrastrando[den]:
			Global.item[den].position = posicion_actual[den]
	
	"""intercambiar posiciones de objetos"""
	intercambio = false
	for pos_act in range(posicion_actual.size()):
		for pos_act2 in range(posicion_actual.size()):
			if posicion_actual[pos_act] == posicion_actual[pos_act2] and pos_act != pos_act2:
				intercambio = true
				
				if posicion_actual[pos_act] == posicion_anterior[pos_act]:
					posicion_actual[pos_act2] = posicion_actual[pos_act]
					posicion_actual[pos_act] = posicion_anterior[pos_act2]
				else:
					posicion_actual[pos_act] = posicion_actual[pos_act2]
					posicion_actual[pos_act2] = posicion_anterior[pos_act]

				Global.item[pos_act].position = posicion_actual[pos_act]
				Global.item[pos_act2].position = posicion_actual[pos_act2]
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	$Label.text = "3"
	if si_color:
		color_verdadero = colores_verdaderos[2]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_2_area_entered(area: Area2D) -> void:
	$Label.text = "2"
	if si_color:
		color_verdadero = colores_verdaderos[1]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)
	
func _on_area_2d_3_area_entered(area: Area2D) -> void:
	$Label.text = "1"
	if si_color:
		color_verdadero = colores_verdaderos[0]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_4_area_entered(area: Area2D) -> void:
	$Label.text = "12"
	if si_color:
		color_verdadero = colores_verdaderos[11]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)
	
func _on_area_2d_5_area_entered(area: Area2D) -> void:
	$Label.text = "11"
	if si_color:
		color_verdadero = colores_verdaderos[10]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_6_area_entered(area: Area2D) -> void:
	$Label.text = "10"
	if si_color:
		color_verdadero = colores_verdaderos[9]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)
	
func _on_area_2d_7_area_entered(area: Area2D) -> void:
	$Label.text = "9"
	if si_color:
		color_verdadero = colores_verdaderos[8]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_8_area_entered(area: Area2D) -> void:
	$Label.text = "8"
	if si_color:
		color_verdadero = colores_verdaderos[7]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)
	
func _on_area_2d_9_area_entered(area: Area2D) -> void:
	$Label.text = "7"
	if si_color:
		color_verdadero = colores_verdaderos[6]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_10_area_entered(area: Area2D) -> void:
	$Label.text = "6"
	if si_color:
		color_verdadero = colores_verdaderos[5]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)

func _on_area_2d_11_area_entered(area: Area2D) -> void:
	$Label.text = "5"
	if si_color:
		color_verdadero = colores_verdaderos[4]
	jugador_ganador = true
	$Indicador/Sprite2D.texture = preload("res://sprites/persona.png")
	$Indicador/Sprite2D.scale = Vector2(0.22,0.21)
	
func _on_area_2d_12_area_entered(area: Area2D) -> void:
	$Label.text = "4"
	if si_color:
		color_verdadero = colores_verdaderos[3]
	jugador_ganador = false
	$Indicador/Sprite2D.texture = preload("res://sprites/demonio.png")
	$Indicador/Sprite2D.scale = Vector2(0.72,0.66)

func _on_button_2_pressed() -> void:
	if not Global.efectos:
		$Button.visible = false
		$Button2.visible = false
		escapar = true
		if poder_girar:
			girar_sprite()

func _on_button_3_pressed() -> void:
	$Button3.visible = false
	$Button4.visible = false
	$Label4.visible = false
	$Button.visible = true
	$Button2.visible = true
	color_elegido = "azul"

func _on_button_4_pressed() -> void:
	$Button3.visible = false
	$Button4.visible = false
	$Label4.visible = false
	$Button.visible = true
	$Button2.visible = true
	color_elegido = "rojo"
	
"""Realiza las transacciones despues de girar la ruleta de apuestas
 	y se convierte en la ruleta de elecciones o sale del combate"""
func _on_timer_timeout() -> void:
	
	activacion_estado = true
	si_color = false
	poder_girar = true
	if color_elegido == color_verdadero:
		Global.dinero += apuesta
		monedas_demonio -= apuesta
	else:
		Global.dinero -= apuesta
		monedas_demonio += apuesta
	$Label2.text = str(Global.dinero)+"$"
	$Label5.text = str(monedas_demonio)+"$"
	if monedas_demonio <= 0 or Global.dinero <= 0:
		poder_girar = false
	if escapar:
		$Timer4.start()
	else:
		$Label3.text = "APUESTA: ?"
		$Label4.visible = false
		$Sprite2D/Sprite2D.visible = true
		$Sprite2D/Sprite2D2.visible = true
		$Sprite2D/Sprite2D3.visible = true
		$Sprite2D/Sprite2D4.visible = true
		$Sprite2D/Sprite2D5.visible = true
		$Sprite2D/Sprite2D6.visible = true
		$Sprite2D/Sprite2D7.visible = true
		$Sprite2D/Sprite2D8.visible = true
		$Sprite2D/Sprite2D9.visible = true
		$Sprite2D/Sprite2D10.visible = true
		$Sprite2D/Sprite2D11.visible = true
		$Sprite2D/Sprite2D12.visible = true
		$Sprite2D/CasillaRoja.visible = false
		$Sprite2D/casilla2D.visible = false
		$Sprite2D/casilla2D2.visible = false
		$Sprite2D/casilla2D3.visible = false
		$Sprite2D/casilla2D4.visible = false
		$Sprite2D/casilla2D5.visible = false
		$Sprite2D/casilla2D6.visible = false
		$Sprite2D/casilla2D7.visible = false
		$Sprite2D/casilla2D8.visible = false
		$Sprite2D/casilla2D9.visible = false
		$Sprite2D/casilla2D10.visible = false
		$Sprite2D/casilla2D11.visible = false
		$Sprite2D/Label.visible = false
		$Sprite2D/Label2.visible = false
		$Sprite2D/Label3.visible = false
		$Sprite2D/Label4.visible = false
		$Sprite2D/Label5.visible = false
		$Sprite2D/Label6.visible = false
		$Sprite2D/Label7.visible = false
		$Sprite2D/Label8.visible = false
		$Sprite2D/Label9.visible = false
		$Sprite2D/Label10.visible = false
		$Sprite2D/Label11.visible = false
		$Sprite2D/Label12.visible = false
		$Indicador/Sprite2D.visible = true
		$Label.visible = false
		$Button.visible = false
		$Button2.visible = false
		$Button5.visible = true
func _on_area_2d_mouse_entered() -> void:
	mouse_area[0] = true
	if not Global.efectos:
		$Inventario/Marcado.visible = true

func _on_area_2d_mouse_exited() -> void:
	mouse_area[0] = false
	if not Global.efectos:
		$Inventario/Marcado.visible = false

func _on_area_2d_2_mouse_entered() -> void:
	mouse_area[1] = true
	if not Global.efectos:
		$Inventario/Marcado2.visible = true

func _on_area_2d_2_mouse_exited() -> void:
	mouse_area[1] = false
	if not Global.efectos:
		$Inventario/Marcado2.visible = false

func _on_area_2d_3_mouse_entered() -> void:
	mouse_area[2] = true
	if not Global.efectos:
		$Inventario/Marcado3.visible = true

func _on_area_2d_3_mouse_exited() -> void:
	mouse_area[2] = false
	if not Global.efectos:
		$Inventario/Marcado3.visible = false

func _on_area_2d_4_mouse_entered() -> void:
	mouse_area[3] = true
	if not Global.efectos:
		$Inventario/Marcado4.visible = true

func _on_area_2d_4_mouse_exited() -> void:
	mouse_area[3] = false
	if not Global.efectos:
		$Inventario/Marcado4.visible = false

func item_inventario_1(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][3] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][3] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][3] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][3] = true
		
func item_inventario_salida_1(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][3] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][3] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][3] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][3] = false
		
func item_inventario_2(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][2] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][2] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][2] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][2] = true
		
func item_inventario_salida_2(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][2] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][2] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][2] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][2] = false

func item_inventario_3(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][1] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][1] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][1] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][1] = true

func item_inventario_salida_3(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][1] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][1] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][1] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][1] = false

func item_inventario_4(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][0] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][0] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][0] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][0] = true
		
func item_inventario_salida_4(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][0] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][0] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][0] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][0] = false

func _on_button_5_pressed() -> void:
		if poder_girar:
			$Button5.visible = false
			girar_sprite()

"""Decide quien puede elegir y cambia a la ruleta de apuestas"""
func _on_timer_2_timeout() -> void:
	$Inventario/Marcado.visible = false
	$Inventario/Marcado2.visible = false
	$Inventario/Marcado3.visible = false
	$Inventario/Marcado4.visible = false
	inicio_habilidades = 0
	inicio = 0
	ruleta_apuestas = true
	si_color = true
	if jugador_ganador:
		$Label4.position.x = -144
		$Label4.text = "¿ROJO O AZUL?"
		$Button3.visible = true
		$Button4.visible = true
	else:
		var colores = ["rojo","azul"]
		color_elegido = colores.pick_random()
		$Label4.position.x = -404
		
		if enemigo == "mosquito":
			color_elegido = "azul"
			
		if color_elegido == "rojo":
			$Label4.text = "EL DEMONIO HA ELEGIDO EL COLOR AZUL"
		else:
			$Label4.text = "EL DEMONIO HA ELEGIDO EL COLOR ROJO"
		$Button.visible = true
		$Button2.visible = true
	
	$Label4.visible = true
	$Sprite2D/Sprite2D.visible = false
	$Sprite2D/Sprite2D2.visible = false
	$Sprite2D/Sprite2D3.visible = false
	$Sprite2D/Sprite2D4.visible = false
	$Sprite2D/Sprite2D5.visible = false
	$Sprite2D/Sprite2D6.visible = false
	$Sprite2D/Sprite2D7.visible = false
	$Sprite2D/Sprite2D8.visible = false
	$Sprite2D/Sprite2D9.visible = false
	$Sprite2D/Sprite2D10.visible = false
	$Sprite2D/Sprite2D11.visible = false
	$Sprite2D/Sprite2D12.visible = false
	$Sprite2D/CasillaRoja.visible = true
	$Sprite2D/casilla2D.visible = true
	$Sprite2D/casilla2D2.visible = true
	$Sprite2D/casilla2D3.visible = true
	$Sprite2D/casilla2D4.visible = true
	$Sprite2D/casilla2D5.visible = true
	$Sprite2D/casilla2D6.visible = true
	$Sprite2D/casilla2D7.visible = true
	$Sprite2D/casilla2D8.visible = true
	$Sprite2D/casilla2D9.visible = true
	$Sprite2D/casilla2D10.visible = true
	$Sprite2D/casilla2D11.visible = true
	$Sprite2D/Label.visible = true
	$Sprite2D/Label2.visible = true
	$Sprite2D/Label3.visible = true
	$Sprite2D/Label4.visible = true
	$Sprite2D/Label5.visible = true
	$Sprite2D/Label6.visible = true
	$Sprite2D/Label7.visible = true
	$Sprite2D/Label8.visible = true
	$Sprite2D/Label9.visible = true
	$Sprite2D/Label10.visible = true
	$Sprite2D/Label11.visible = true
	$Sprite2D/Label12.visible = true
	$Indicador/Sprite2D.visible = false
	$Label.visible = true
	
"""Bomba de humo que sirve como transición entre ruletas o escapar del combate"""
func _on_timer_3_timeout() -> void:
	if not escapar:
		$CPUParticles2D.emitting = true

"""El usuario se escapa del combate"""
func _on_timer_4_timeout() -> void:
	get_tree().quit()

"""efectos de los items"""
func _on_tiempo_efectos_timeout() -> void:
	var si = true
	"""items"""
	for p in range(inicio,posiciones_inventario.size()):
		for i in range(Global.item.size()):
			if Global.item[i].position == posiciones_inventario[p] and si:
				"""rosa_roja"""
				if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/rosa_roja.png"):
					Global.item[i].get_node("rosa_roja").emitting = false
					if una_vez[i]:
						casillas_azules_modificadas[i].texture = preload("res://sprites/casilla_roja.png")
						colores_verdaderos[orden_casillas_azules_modificadas[i]] = "rojo"
						casillas_azules_modificadas[i].get_node("rosa_roja2").emitting = false
					
						una_vez[i] = false
					
				"""rosa_azul"""
				if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/rosa_azul.png"):
					Global.item[i].get_node("rosa_azul").emitting = false
					if una_vez[i]:
						casillas_rojas_modificadas[i].texture = preload("res://sprites/casilla_azul.png")
						colores_verdaderos[orden_casillas_rojas_modificadas[i]] = "azul"
						casillas_rojas_modificadas[i].get_node("rosa_azul2").emitting = false
					
						una_vez[i] = false
					
				"""boton_reinicio"""
				if Global.item[i].visible and Global.item[i].get_node("Sprite2D").texture == preload("res://sprites/boton_reinicio.png"):
					Global.item[i].get_node("boton_reinicio").emitting = false
					if not jugador_ganador:
						for ca in range(casillas_azules.size()):
							for cao in range(casillas_azules_original.size()):
								if ca == cao and casillas_azules[ca] != casillas_azules_original[cao]:
									if casillas_azules_original[cao].has_node("rosa_azul2"):
										casillas_azules_original[cao].get_node("rosa_azul2").emitting = false
									else:
										casillas_azules_original[cao].get_node("rosa_azul2_habilidades").emitting = false
									casillas_azules_original[cao].texture = preload("res://sprites/casilla_azul.png")
									colores_verdaderos[orden_casillas_azules_original[cao]] = "azul"
									casillas_azules[ca] = casillas_azules_original[cao]
									orden_casillas_azules[ca] = orden_casillas_azules_original[cao]
						for cr in range(casillas_rojas.size()):
								for cro in range(casillas_rojas_original.size()):
									if cr == cro and casillas_rojas[cr] != casillas_rojas_original[cro]:
										casillas_rojas_original[cro].get_node("rosa_roja2").emitting = false
										casillas_rojas_original[cro].texture = preload("res://sprites/casilla_roja.png")
										colores_verdaderos[orden_casillas_rojas_original[cro]] = "rojo"
										casillas_rojas[cr] = casillas_rojas_original[cro]
										orden_casillas_rojas[cr] = orden_casillas_rojas_original[cro]
					else:
							for ca in range(casillas_azules.size()):
								if casillas_azules[ca] != null:
									for it in range(Global.item.size()):
										if casillas_azules_modificadas[it] == casillas_azules_original[ca]:
											casillas_azules_modificadas[it].get_node("rosa_roja2").emitting = false
											casillas_azules_modificadas[it].texture =  preload("res://sprites/casilla_roja.png")
											colores_verdaderos[orden_casillas_azules_modificadas[it]] = "rojo"
											casillas_azules[ca] = null
											orden_casillas_azules[ca] = null
									for h in range(habilidades.size()):
										if casillas_azules_habilidad[h] == casillas_azules_original[ca]:
											casillas_azules_habilidad[h].get_node("rosa_roja2_habilidades").emitting = false
											casillas_azules_habilidad[h].texture = preload("res://sprites/casilla_roja.png")
											colores_verdaderos[orden_azules_habilidad[h]] = "rojo"
											casillas_azules[ca] = null
											orden_casillas_azules[ca] = null
							for cr in range(casillas_rojas.size()):
								if casillas_rojas[cr] != null:
									for it in range(Global.item.size()):
										if casillas_rojas_modificadas[it] == casillas_rojas_original[cr]:
											casillas_rojas_modificadas[it].get_node("rosa_azul2").emitting = false
											casillas_rojas_modificadas[it].texture =  preload("res://sprites/casilla_azul.png")
											colores_verdaderos[orden_casillas_rojas_modificadas[it]] = "azul"
											casillas_rojas[cr] = null
											orden_casillas_rojas[cr] = null
				si = false
	
	"""habilidades"""
	for c in range(inicio_habilidades,habilidades.size()):
		for h in range(habilidades.size()):
			if habilidades[h].position == posiciones_habilidades[c] and si:
				habilidades[h].get_node("rosa_roja_habilidades").emitting = false
			
				"""rosa_roja"""
				if habilidades[h].get_node("habilidad").texture == preload("res://sprites/rosa_roja.png"):
					if habilidad_identificada == habilidades[h]:
						una_vez_habilidades[h] = false
						pass
					else:
						if una_vez_habilidades[h]:
							casillas_azules_habilidad[h].texture = preload("res://sprites/casilla_roja.png")
							colores_verdaderos[orden_azules_habilidad[h]] = "rojo"
							casillas_azules_habilidad[h].get_node("rosa_roja2_habilidades").emitting = false
					
							una_vez_habilidades[h] = false
							
				si = false
				inicio_habilidades += 1
				if h == habilidades.size()-1:
					Global.efectos = false
	
	"""actualizando algunas variables"""
	timer_efectos = true
	inicio += 1
	
	"""no interactuar con las habilidades"""
	for h in range(habilidades.size()):
		habilidades[h].get_node("MarcadoHabilidades/marcado").visible = false
		habilidades[h].get_node("Label6").visible = false
	
	$Inventario/Marcado.visible = false
	$Inventario/Marcado2.visible = false
	$Inventario/Marcado3.visible = false
	$Inventario/Marcado4.visible = false

func _on_area_tu_dinero_mouse_entered() -> void:
	$Label7.visible = true

func _on_area_tu_dinero_mouse_exited() -> void:
	$Label7.visible = false

func _on_area_dinero_enemigo_mouse_entered() -> void:
	$Label8.visible = true

func _on_area_dinero_enemigo_mouse_exited() -> void:
	$Label8.visible = false

func _on_area_apuesta_mouse_entered() -> void:
	$Label9.visible = true

func _on_area_apuesta_mouse_exited() -> void:
	$Label9.visible = false

func _on_area_efecto_estado_mouse_entered() -> void:
	$Label10.visible = true

func _on_area_efecto_estado_mouse_exited() -> void:
	$Label10.visible = false
