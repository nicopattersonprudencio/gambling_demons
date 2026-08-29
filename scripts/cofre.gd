extends Node2D


# ============================================================
# INVENTARIO
# ============================================================

var posiciones_inventario = [
	Vector2(-778, -218),
	Vector2(-778, -73),
	Vector2(-778, 71),
	Vector2(-778, 215)
]

var objeto_inventario = [
	[false, false, false, false],
	[false, false, false, false],
	[false, false, false, false],
	[false, false, false, false]
]

var posicion_actual = [
	posiciones_inventario[0],
	posiciones_inventario[1],
	posiciones_inventario[2],
	posiciones_inventario[3]
]

var mouse_area = [
	false,
	false,
	false,
	false
]

var intercambio = false


# ============================================================
# DATOS DE LOS ITEMS
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
# APLICAR DATOS A UN ITEM
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

	item.set_meta("tipo_item", tipo)


# ============================================================
# OBTENER TIPO DE ITEM
# ============================================================

func obtener_tipo_item(item: Area2D) -> String:

	if item.has_meta("tipo_item"):
		return item.get_meta("tipo_item")

	return ""


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	# --------------------------------------------------------
	# LIMPIAR ESTADO DEL INVENTARIO
	# --------------------------------------------------------

	objeto_inventario = [
		[false, false, false, false],
		[false, false, false, false],
		[false, false, false, false],
		[false, false, false, false]
	]

	mouse_area = [
		false,
		false,
		false,
		false
	]

	intercambio = false


	# --------------------------------------------------------
	# ITEM 0
	# --------------------------------------------------------

	Global.item[0].add_to_group("items")

	Global.item[0].position = posiciones_inventario[0]

	aplicar_datos_item(
		Global.item[0],
		"rosa_roja"
	)

	add_child(Global.item[0])


	# --------------------------------------------------------
	# ITEM 1
	# --------------------------------------------------------

	Global.item[1].add_to_group("items")

	Global.item[1].position = posiciones_inventario[1]

	aplicar_datos_item(
		Global.item[1],
		"rosa_azul"
	)

	add_child(Global.item[1])


	# --------------------------------------------------------
	# ITEM 2
	# --------------------------------------------------------

	Global.item[2].add_to_group("items")

	Global.item[2].position = posiciones_inventario[2]

	aplicar_datos_item(
		Global.item[2],
		"boton_reinicio"
	)

	add_child(Global.item[2])


	# --------------------------------------------------------
	# ITEM 3
	# --------------------------------------------------------

	Global.item[3].add_to_group("items")

	Global.item[3].position = posiciones_inventario[3]

	aplicar_datos_item(
		Global.item[3],
		"candado_cerrado"
	)

	add_child(Global.item[3])


	# --------------------------------------------------------
	# DINERO
	# --------------------------------------------------------

	$Label2.text = str(Global.dinero) + "$"


# ============================================================
# PROCESS
# ============================================================

func _process(delta):

	# ========================================================
	# POSICIONES ANTERIORES
	# ========================================================

	var posicion_anterior = posicion_actual.duplicate()


	# ========================================================
	# OCULTAR DESCRIPCIONES MIENTRAS SE ARRASTRA
	# ========================================================

	for i in range(Global.item.size()):

		if Global.arrastrando[i]:

			Global.item[i].get_node("Label").visible = false


	# ========================================================
	# COLOCAR OBJETOS EN LAS CASILLAS
	# ========================================================

	for objeto_inv in range(objeto_inventario.size()):

		for objeto in range(objeto_inventario[objeto_inv].size()):

			if objeto_inventario[objeto_inv][
				objeto_inventario[objeto_inv].size() - objeto - 1
			]:

				if (
					not Global.arrastrando[objeto_inv]
					and mouse_area[objeto]
					and not intercambio
				):

					Global.item[objeto_inv].position = (
						posiciones_inventario[
							posiciones_inventario.size() - 1 - objeto
						]
					)

					posicion_actual[objeto_inv] = (
						Global.item[objeto_inv].position
					)


	# ========================================================
	# NO SALIR DEL INVENTARIO
	# ========================================================

	var dentro = [
		false,
		false,
		false,
		false
	]

	for espacio in posiciones_inventario:

		for i in range(Global.item.size()):

			if espacio == Global.item[i].position:

				dentro[i] = true


	for i in range(dentro.size()):

		if (
			not dentro[i]
			and not Global.arrastrando[i]
		):

			Global.item[i].position = posicion_actual[i]


	# ========================================================
	# INTERCAMBIAR POSICIONES
	# ========================================================

	intercambio = false

	for i in range(posicion_actual.size()):

		for j in range(posicion_actual.size()):

			if (
				posicion_actual[i]
				== posicion_actual[j]
				and i != j
			):

				intercambio = true

				if (
					posicion_actual[i]
					== posicion_anterior[i]
				):

					posicion_actual[j] = posicion_actual[i]

					posicion_actual[i] = (
						posicion_anterior[j]
					)

				else:

					posicion_actual[i] = posicion_actual[j]

					posicion_actual[j] = (
						posicion_anterior[i]
					)

				Global.item[i].position = posicion_actual[i]
				Global.item[j].position = posicion_actual[j]


# ============================================================
# ÁREA 1
# ============================================================

func _on_area_2d_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][3] = true


func _on_area_2d_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][3] = false


# ============================================================
# ÁREA 2
# ============================================================

func _on_area_2d_2_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][2] = true


func _on_area_2d_2_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][2] = false


# ============================================================
# ÁREA 3
# ============================================================

func _on_area_2d_3_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][1] = true


func _on_area_2d_3_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][1] = false


# ============================================================
# ÁREA 4
# ============================================================

func _on_area_2d_4_area_entered(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][0] = true


func _on_area_2d_4_area_exited(area: Area2D) -> void:

	for i in range(Global.item.size()):

		if area == Global.item[i]:

			objeto_inventario[i][0] = false


# ============================================================
# MOUSE CASILLA 1
# ============================================================

func _on_area_2d_mouse_entered() -> void:

	mouse_area[0] = true

	if not Global.efectos:

		$Inventario/Marcado.visible = true


func _on_area_2d_mouse_exited() -> void:

	mouse_area[0] = false

	if not Global.efectos:

		$Inventario/Marcado.visible = false


# ============================================================
# MOUSE CASILLA 2
# ============================================================

func _on_area_2d_2_mouse_entered() -> void:

	mouse_area[1] = true

	if not Global.efectos:

		$Inventario/Marcado2.visible = true


func _on_area_2d_2_mouse_exited() -> void:

	mouse_area[1] = false

	if not Global.efectos:

		$Inventario/Marcado2.visible = false


# ============================================================
# MOUSE CASILLA 3
# ============================================================

func _on_area_2d_3_mouse_entered() -> void:

	mouse_area[2] = true

	if not Global.efectos:

		$Inventario/Marcado3.visible = true


func _on_area_2d_3_mouse_exited() -> void:

	mouse_area[2] = false

	if not Global.efectos:

		$Inventario/Marcado3.visible = false


# ============================================================
# MOUSE CASILLA 4
# ============================================================

func _on_area_2d_4_mouse_entered() -> void:

	mouse_area[3] = true

	if not Global.efectos:

		$Inventario/Marcado4.visible = true


func _on_area_2d_4_mouse_exited() -> void:

	mouse_area[3] = false

	if not Global.efectos:

		$Inventario/Marcado4.visible = false


# ============================================================
# DINERO
# ============================================================

func _on_area_tu_dinero_mouse_entered() -> void:

	$Label7.visible = true


func _on_area_tu_dinero_mouse_exited() -> void:

	$Label7.visible = false
