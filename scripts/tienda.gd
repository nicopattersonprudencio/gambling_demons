extends Node2D

var posiciones_inventario = [
	Vector2(-778,-218),
	Vector2(-778,-73),
	Vector2(-778,71),
	Vector2(-778,215)
]

var objeto_inventario = [
	[false,false,false,false],
	[false,false,false,false],
	[false,false,false,false],
	[false,false,false,false]
]

var posicion_actual = [
	posiciones_inventario[0],
	posiciones_inventario[1],
	posiciones_inventario[2],
	posiciones_inventario[3]
]

var mouse_area = [false,false,false,false]
var intercambio = false

var tipos_items = [
	"rosa_roja",
	"rosa_azul",
	"candado_cerrado",
	"boton_reinicio"
]

var instancia = preload("res://scenes/item_tienda.tscn")
var item_tienda = [
	instancia.instantiate(),
	instancia.instantiate(),
	instancia.instantiate()
]


# ============================================================
# CONFIGURACIÓN DE TODOS LOS ITEMS
# ============================================================

var datos_items = {

	"rosa_roja": {
		"texture": preload("res://sprites/rosa_roja.png"),
		"scale": Vector2(0.15, 0.15),
		"collision_size": Vector2(117, 90),
		"descripcion": "Cambia una casilla\naleatoria al rojo\nal principio del combate."
	},

	"rosa_azul": {
		"texture": preload("res://sprites/rosa_azul.png"),
		"scale": Vector2(0.15, 0.15),
		"collision_size": Vector2(117, 90),
		"descripcion": "Cambia una casilla\naleatoria al azul\nal principio del combate."
	},

	"candado_cerrado": {
		"texture": preload("res://sprites/candado.png"),
		"scale": Vector2(0.3, 0.3),
		"collision_size": Vector2(69, 92),
		"descripcion": "Anula una habilidad cualquiera\ndel oponente cada turno."
	},

	"boton_reinicio": {
		"texture": preload("res://sprites/boton_reinicio.png"),
		"scale": Vector2(0.5, 0.45),
		"collision_size": Vector2(66, 115),
		"descripcion": "Toda vez que el jugador no pueda elegir,\nla ruleta vuelve a su estado normal durante 1 turno."
	}
}


# ============================================================
# APLICAR LAS PROPIEDADES DE UN ITEM
# ============================================================

func aplicar_datos_item(item: Area2D, tipo: String) -> void:

	if not datos_items.has(tipo):
		print("ERROR: No existe el tipo de item: ", tipo)
		return

	var datos = datos_items[tipo]

	item.get_node("Sprite2D").texture = datos["texture"]
	item.get_node("Sprite2D").scale = datos["scale"]
	item.get_node("CollisionShape2D").shape.size = datos["collision_size"]
	item.get_node("Label").text = datos["descripcion"]

	# Guardamos qué tipo de item es.
	item.set_meta("tipo_item", tipo)


# ============================================================
# OBTENER EL TIPO DE UN ITEM
# ============================================================

func obtener_tipo_item(item: Area2D) -> String:

	if item.has_meta("tipo_item"):
		return item.get_meta("tipo_item")

	return ""


# ============================================================
# INTERCAMBIAR ITEM DE TIENDA CON ITEM DEL INVENTARIO
# ============================================================

func intercambiar_item_tienda_con_inventario(
	item_tienda_obj: Area2D,
	item_inventario: Area2D
) -> void:

	var tipo_tienda = obtener_tipo_item(item_tienda_obj)
	var tipo_inventario = obtener_tipo_item(item_inventario)

	if tipo_tienda == "" or tipo_inventario == "":
		print("ERROR: Uno de los items no tiene tipo.")
		return

	print("INTERCAMBIO:")
	print("Tienda: ", tipo_tienda)
	print("Inventario: ", tipo_inventario)

	# --------------------------------------------------------
	# INTERCAMBIAMOS LOS DATOS
	# --------------------------------------------------------

	# El objeto del inventario pasa a ser el objeto que
	# estaba en la tienda.
	aplicar_datos_item(item_inventario, tipo_tienda)

	# El objeto de la tienda pasa a ser el objeto que
	# estaba en el inventario.
	aplicar_datos_item(item_tienda_obj, tipo_inventario)

	# --------------------------------------------------------
	# ACTUALIZAMOS EL INVENTARIO
	# --------------------------------------------------------

	var indice_inventario = -1

	for i in range(Global.item.size()):
		if Global.item[i] == item_inventario:
			indice_inventario = i
			break

	if indice_inventario != -1:
		# El inventario ahora contiene el objeto de la tienda.
		print(
			"El inventario[",
			indice_inventario,
			"] ahora es: ",
			tipo_tienda
		)

	# --------------------------------------------------------
	# EL ITEM DE LA TIENDA VUELVE A SU POSICIÓN
	# --------------------------------------------------------

	item_tienda_obj.position = item_tienda_obj.get_meta(
		"posicion_tienda"
	)

	# --------------------------------------------------------
	# QUITAMOS EL BRILLO
	# --------------------------------------------------------

	for i in range(item_tienda.size()):
		if item_tienda[i] == item_tienda_obj:
			Global.brillo[i] = false
			break


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	for i in range(item_tienda.size()):

		var item = item_tienda[i]

		var sprite = item.get_node("Sprite2D")
		sprite.material = sprite.material.duplicate()

		item.set_meta("indice_tienda", i)


	# ========================================================
	# POSICIONES DE LA TIENDA
	# ========================================================

	item_tienda[0].position = Vector2(-287,330)
	item_tienda[1].position = Vector2(0,330)
	item_tienda[2].position = Vector2(287,330)

	for item in item_tienda:
		item.set_meta("posicion_tienda", item.position)


	# ========================================================
	# ITEMS DEL INVENTARIO
	# ========================================================

	Global.item[0].add_to_group("items")
	Global.item[0].position = posiciones_inventario[0]
	aplicar_datos_item(Global.item[0], "rosa_roja")
	add_child(Global.item[0])


	Global.item[1].add_to_group("items")
	Global.item[1].position = posiciones_inventario[1]
	aplicar_datos_item(Global.item[1], "rosa_azul")
	add_child(Global.item[1])


	Global.item[2].add_to_group("items")
	Global.item[2].position = posiciones_inventario[2]
	aplicar_datos_item(Global.item[2], "boton_reinicio")
	add_child(Global.item[2])


	Global.item[3].add_to_group("items")
	Global.item[3].position = posiciones_inventario[3]
	aplicar_datos_item(Global.item[3], "candado_cerrado")
	add_child(Global.item[3])


	# ========================================================
	# DINERO
	# ========================================================

	$Label2.text = str(Global.dinero) + "$"


	# ========================================================
	# ITEMS DE LA TIENDA
	# ========================================================

	randomize()

	for i in range(3):

		var item_seleccionado = tipos_items.pick_random()

		aplicar_datos_item(
			item_tienda[i],
			item_seleccionado
		)

		add_child(item_tienda[i])

		print(
			"Item tienda ",
			i,
			": ",
			item_seleccionado
		)


# ============================================================
# BRILLO DE LOS ITEMS DE LA TIENDA
# ============================================================

func _process(delta):

	if Global.brillo[0]:
		item_tienda[0].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0.5
		)
	else:
		item_tienda[0].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0
		)


	if Global.brillo[1]:
		item_tienda[1].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0.5
		)
	else:
		item_tienda[1].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0
		)


	if Global.brillo[2]:
		item_tienda[2].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0.5
		)
	else:
		item_tienda[2].get_node("Sprite2D").material.set_shader_parameter(
			"glow_strength",
			0
		)


	# ========================================================
	# INVENTARIO
	# ========================================================

	var posicion_anterior = [
		posicion_actual[0],
		posicion_actual[1],
		posicion_actual[2],
		posicion_actual[3]
	]


	# Hacer invisibles las descripciones

	for it in range(Global.item.size()):

		if Global.arrastrando[it]:
			Global.item[it].get_node("Label").visible = false


	# Posiciones

	for objeto_inv in range(objeto_inventario.size()):

		for objeto in range(objeto_inventario[0].size()):

			if objeto_inventario[objeto_inv][
				objeto_inventario[0].size()-objeto-1
			]:

				if (
					not Global.arrastrando[objeto_inv]
					and mouse_area[objeto]
					and not intercambio
				):

					Global.item[objeto_inv].position = posiciones_inventario[
						posiciones_inventario.size()-1-objeto
					]

					posicion_actual[objeto_inv] = Global.item[
						objeto_inv
					].position


	# ========================================================
	# NO SALIR DEL INVENTARIO
	# ========================================================

	var dentro = [false,false,false,false]

	for espacio in posiciones_inventario:

		for it in range(Global.item.size()):

			if espacio == Global.item[it].position:
				dentro[it] = true


	for den in range(dentro.size()):

		if not dentro[den] and not Global.arrastrando[den]:

			Global.item[den].position = posicion_actual[den]


	# ========================================================
	# INTERCAMBIAR POSICIONES DE OBJETOS DEL INVENTARIO
	# ========================================================

	intercambio = false

	for pos_act in range(posicion_actual.size()):

		for pos_act2 in range(posicion_actual.size()):

			if (
				posicion_actual[pos_act]
				== posicion_actual[pos_act2]
				and pos_act != pos_act2
			):

				intercambio = true

				if posicion_actual[pos_act] == posicion_anterior[pos_act]:

					posicion_actual[pos_act2] = posicion_actual[pos_act]
					posicion_actual[pos_act] = posicion_anterior[pos_act2]

				else:

					posicion_actual[pos_act] = posicion_actual[pos_act2]
					posicion_actual[pos_act2] = posicion_anterior[pos_act]

				Global.item[pos_act].position = posicion_actual[pos_act]
				Global.item[pos_act2].position = posicion_actual[pos_act2]


# ============================================================
# ÁREAS DEL INVENTARIO
# ============================================================

func _on_area_2d_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][3] = true


func _on_area_2d_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][3] = false


func _on_area_2d_2_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][2] = true


func _on_area_2d_2_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][2] = false


func _on_area_2d_3_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][1] = true


func _on_area_2d_3_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][1] = false


func _on_area_2d_4_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][0] = true


func _on_area_2d_4_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):
		if area == Global.item[i]:
			objeto_inventario[i][0] = false


# ============================================================
# MOUSE INVENTARIO
# ============================================================

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
