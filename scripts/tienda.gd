extends Node2D

var posiciones_inventario = [Vector2(-778,-218),Vector2(-778,-73),Vector2(-778,71),Vector2(-778,215)]
var objeto_inventario = [[false,false,false,false],[false,false,false,false],[false,false,false,false],[false,false,false,false]]
var posicion_actual = [posiciones_inventario[0],posiciones_inventario[1],posiciones_inventario[2],posiciones_inventario[3]]
var mouse_area = [false,false,false,false]
var intercambio = false
var tipos_items = ["rosa_roja","rosa_azul","candado_cerrado","boton_reinicio"]

var instancia = preload("res://scenes/item_tienda.tscn")
var item_tienda = [instancia.instantiate(),instancia.instantiate(),instancia.instantiate()]

func _ready() -> void:
	for item in item_tienda:
		var sprite = item.get_node("Sprite2D")
		sprite.material = sprite.material.duplicate()
	
	item_tienda[0].position = Vector2(-287,330)
	item_tienda[1].position = Vector2(0,330)
	item_tienda[2].position = Vector2(287,330)
	
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

	"""Dinero del jugador"""
	$Label2.text = str(Global.dinero) + "$"
	
	"""Items de la tienda"""
	randomize()
	for i in range(3):
		var item_seleccionado = tipos_items.pick_random()
		if item_seleccionado == "rosa_roja":
			item_tienda[i].get_node("Sprite2D").texture = preload("res://sprites/rosa_roja.png")
			item_tienda[i].get_node("Sprite2D").scale = Vector2(0.15,0.15)
		if item_seleccionado == "rosa_azul":
			item_tienda[i].get_node("Sprite2D").texture = preload("res://sprites/rosa_azul.png")
			item_tienda[i].get_node("Sprite2D").scale = Vector2(0.15,0.15)
		if item_seleccionado == "candado_cerrado":
			item_tienda[i].get_node("Sprite2D").texture = preload("res://sprites/candado.png")
			item_tienda[i].get_node("Sprite2D").scale = Vector2(0.3,0.3)
		if item_seleccionado == "boton_reinicio":
			item_tienda[i].get_node("Sprite2D").texture = preload("res://sprites/boton_reinicio.png")
			item_tienda[i].get_node("Sprite2D").scale = Vector2(0.5,0.45)
		add_child(item_tienda[i])
		print(item_tienda[i].name)
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][3] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][3] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][3] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][3] = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][3] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][3] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][3] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][3] = false

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][2] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][2] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][2] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][2] = true

func _on_area_2d_2_area_exited(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][2] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][2] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][2] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][2] = false

func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][1] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][1] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][1] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][1] = true

func _on_area_2d_3_area_exited(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][1] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][1] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][1] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][1] = false

func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][0] = true
	if area.name == Global.item[1].name:
		objeto_inventario[1][0] = true
	if area.name == Global.item[2].name:
		objeto_inventario[2][0] = true
	if area.name == Global.item[3].name:
		objeto_inventario[3][0] = true

func _on_area_2d_4_area_exited(area: Area2D) -> void:
	if area.name == Global.item[0].name:
		objeto_inventario[0][0] = false
	if area.name == Global.item[1].name:
		objeto_inventario[1][0] = false
	if area.name == Global.item[2].name:
		objeto_inventario[2][0] = false
	if area.name == Global.item[3].name:
		objeto_inventario[3][0] = false

func _process(delta):
	"""brillo de los objetos de la tienda"""
	if Global.brillo[0]:
		item_tienda[0].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0.5)
	else:
		item_tienda[0].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0)
		
	if Global.brillo[1]:
		item_tienda[1].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0.5)
	else:
		item_tienda[1].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0)
		
	if Global.brillo[2]:
		item_tienda[2].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0.5)
	else:
		item_tienda[2].get_node("Sprite2D").material.set_shader_parameter("glow_strength", 0)
	
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

func _on_area_tu_dinero_mouse_entered() -> void:
	$Label7.visible = true

func _on_area_tu_dinero_mouse_exited() -> void:
	$Label7.visible = false
