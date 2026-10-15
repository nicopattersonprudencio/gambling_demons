extends Node2D

var duracion_animacion: float = 1.0

# Indica si cada objeto de la tienda ha sido comprado
var vendido = [false, false, false]

# Precio de cada objeto de la tienda
var precios = [3, 3, 3]

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
	"boton_reinicio",
	"regadera_dinero"
]

var instancia = preload("res://scenes/item_tienda.tscn")
var item_tienda = [
	instancia.instantiate(),
	instancia.instantiate(),
	instancia.instantiate()
]

"""regadera"""
var cantidad_flores = 0
var cantidad_regaderas = 0

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
		"descripcion": "Tiene una probabilidad\ndel 33% de anular\nuna habilidad cualquiera\ndel enemigo cada turno."
	},

	"boton_reinicio": {
		"texture": preload("res://sprites/boton_reinicio.png"),
		"scale": Vector2(0.5, 0.45),
		"collision_size": Vector2(66, 115),
		"descripcion": "Toda vez que no puedas elegir,\nla ruleta vuelve a su estado normal durante un turno."
	},
	"regadera_dinero": {
		"texture": preload("res://sprites/regadera.png"),
		"scale": Vector2(0.2, 0.2),
		"collision_size": Vector2(130, 120),
		"descripcion": "Toda vez que ganes\nuna apuesta, gana 1$\nadicional por cada flor\nequipada. Actualmente: 0$"
	}
}

func comprar_item(indice: int) -> void:

	# Evitar comprar dos veces el mismo objeto
	if vendido[indice]:
		return

	var precio = precios[indice]

	# Comprobar que tenemos suficiente dinero
	if Global.dinero < precio:
		$AudioStreamPlayer2.play()
		return

	# Restar dinero
	Global.dinero -= precio
	$AudioStreamPlayer.play()
	# Marcar como vendido
	vendido[indice] = true

	# Actualizar el dinero mostrado
	var dinero_inicial = int($Label2.text.replace("$", ""))
	var dinero_final = Global.dinero
	
	var audio = $AudioStreamPlayer6
	var frecuencia_base = 0.8
	var incremento_frecuencia = 0.08
	
	var tween_dinero = create_tween()
	tween_dinero.tween_method(
	func(valor: int):
		var valor_actual = int($Label2.text.replace("$", ""))

		if valor != valor_actual:
			# Aumentar el tono al ganar dinero y reducirlo al perderlo
			if dinero_final > dinero_inicial:
				audio.pitch_scale = min(
					frecuencia_base + abs(valor - dinero_inicial) * incremento_frecuencia / max(abs(dinero_final - dinero_inicial), 1),
					1.5
				)
			elif dinero_final < dinero_inicial:
				audio.pitch_scale = max(
					frecuencia_base - abs(valor - dinero_inicial) * incremento_frecuencia / max(abs(dinero_final - dinero_inicial), 1),
					0.5
				)

			audio.play()

			var giro = create_tween()
			giro.tween_property($Label2, "rotation_degrees", 20.0, 0.1)
			giro.tween_property($Label2, "rotation_degrees", 0.0, 0.15)

		$Label2.text = str(valor) + "$",
	dinero_inicial,
	dinero_final,
	duracion_animacion
).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# Mostrar X en rojo en el precio correspondiente
	if indice == 0:
		$Label.text = " X"
		$Label.add_theme_color_override("font_color", Color.RED)

	elif indice == 1:
		$Label3.text = " X"
		$Label3.add_theme_color_override("font_color", Color.RED)

	elif indice == 2:
		$Label4.text = " X"
		$Label4.add_theme_color_override("font_color", Color.RED)

	# Quitar el brillo
	Global.brillo[indice] = false

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

	var etiqueta = item.get_node("Label")
	etiqueta.bbcode_enabled = true
	etiqueta.text = colorear_numeros(datos["descripcion"])

	item.set_meta("tipo_item", tipo)

func colorear_numeros(texto: String) -> String:
	var regex = RegEx.new()
	regex.compile(r"\$-?\d+(?:[.,]\d+)?|-?\d+(?:[.,]\d+)?\$|-?\d+(?:[.,]\d+)?%")

	var resultado = ""
	var posicion = 0

	for coincidencia in regex.search_all(texto):
		resultado += texto.substr(posicion, coincidencia.get_start() - posicion)

		var fragmento = coincidencia.get_string()

		if fragmento.begins_with("$") or fragmento.ends_with("$"):
			resultado += "[color=#228B22]" + fragmento + "[/color]"
		else:
			resultado += "[color=#0000FF]" + fragmento + "[/color]"

		posicion = coincidencia.get_end()

	resultado += texto.substr(posicion)

	return resultado

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

	# ========================================================
	# COMPROBAR QUE EL OBJETO HA SIDO COMPRADO
	# ========================================================

	if not item_tienda_obj.has_meta("indice_tienda"):
		return

	var indice_tienda = item_tienda_obj.get_meta("indice_tienda")

	if not vendido[indice_tienda]:
		return


	# ========================================================
	# OBTENER LOS TIPOS
	# ========================================================

	var tipo_tienda = obtener_tipo_item(item_tienda_obj)
	var tipo_inventario = obtener_tipo_item(item_inventario)

	if tipo_tienda == "" or tipo_inventario == "":
		print("ERROR: Uno de los items no tiene tipo.")
		return

	# ========================================================
	# GUARDAR VISIBILIDAD
	# ========================================================

	var visible_tienda = item_tienda_obj.visible
	var visible_inventario = item_inventario.visible


	# ========================================================
	# INTERCAMBIAR PROPIEDADES
	# ========================================================

	aplicar_datos_item(
		item_inventario,
		tipo_tienda
	)

	aplicar_datos_item(
		item_tienda_obj,
		tipo_inventario
	)


	# ========================================================
	# INTERCAMBIAR ESTADO DE VISIBILIDAD
	# ========================================================

	item_inventario.visible = visible_tienda
	item_tienda_obj.visible = visible_inventario


	# ========================================================
	# EL ITEM DE LA TIENDA VUELVE A SU POSICIÓN
	# ========================================================

	item_tienda_obj.position = item_tienda_obj.get_meta(
		"posicion_tienda"
	)


	# ========================================================
	# QUITAR BRILLO
	# ========================================================

	Global.brillo[indice_tienda] = false

func crear_items_inventario() -> void:

	for i in range(4):

		var item = Global.item[i]

		if not is_instance_valid(item):
			continue

		item.add_to_group("items")

		item.position = posiciones_inventario[i]

		item.visible = true


		var tipo = obtener_tipo_item(item)

		if tipo != "":

			aplicar_datos_item(
				item,
				tipo
			)

func flotar_vendedor() -> void:
	var posicion_original = $Vendedor.position

	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property($Vendedor, "position:y", posicion_original.y + 50, 2)
	tween.tween_property($Vendedor, "position:y", posicion_original.y, 3)

func _ready() -> void:
	"""animacion del vendedor"""
	flotar_vendedor()
	
	"""contar regaderas"""
	for it in range(Global.item.size()):
		if Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/regadera.png") and Global.item[it].visible:
			cantidad_regaderas += 1
	
	"""modificar descipción de regadera_dinero"""
	for it in range(Global.item.size()):
		if (Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/rosa_roja.png") or Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/rosa_azul.png")) and Global.item[it].get_node("Sprite2D").visible:
			cantidad_flores += 1
	
	for it in range(Global.item.size()):
		if Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/regadera.png"):
			Global.item[it].get_node("Label").text = "Toda vez que ganes\nuna apuesta, gana 1$\nadicional por cada flor\nequipada. Actualmente: "+str(cantidad_flores)+"$"
			Global.item[it].get_node("Label").text = colorear_numeros(Global.item[it].get_node("Label").text)
	
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

# ============================================================
# BRILLO DE LOS ITEMS DE LA TIENDA
# ============================================================

func _process(delta):
	"""comproabar si una flor se ha eliminado"""
	var cantidad_flores2 = 0
	for it in range(Global.item.size()):
		if (Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/rosa_roja.png") or Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/rosa_azul.png")) and Global.item[it].visible:
			cantidad_flores2 += 1
	if cantidad_flores != cantidad_flores2:
		cantidad_flores = cantidad_flores2
		for ite in range(Global.item.size()):
			if Global.item[ite].get_node("Sprite2D").texture == preload("res://sprites/regadera.png"):
				Global.item[ite].get_node("Label").text = "Toda vez que ganes\nuna apuesta, gana 1$\nadicional por cada flor\nequipada. Actualmente: "+str(cantidad_flores)+"$"
				Global.item[ite].get_node("Label").text = colorear_numeros(Global.item[ite].get_node("Label").text)
	
	"""comprobar si se agrega una regadera nueva"""
	var cantidad_regaderas2 = 0
	for it in range(Global.item.size()):
		if Global.item[it].get_node("Sprite2D").texture == preload("res://sprites/regadera.png") and Global.item[it].visible:
			cantidad_regaderas2 += 1
	if cantidad_regaderas != cantidad_regaderas2:
		cantidad_regaderas = cantidad_regaderas2
		for ite in range(Global.item.size()):
			if Global.item[ite].get_node("Sprite2D").texture == preload("res://sprites/regadera.png"):
				Global.item[ite].get_node("Label").text = "Toda vez que ganes\nuna apuesta, gana 1$\nadicional por cada flor\nequipada. Actualmente: "+str(cantidad_flores)+"$"
				Global.item[ite].get_node("Label").text = colorear_numeros(Global.item[ite].get_node("Label").text)
		
	
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
	$AudioStreamPlayer3.play()
	mouse_area[0] = true

	if not Global.efectos:
		$Inventario/Marcado.visible = true


func _on_area_2d_mouse_exited() -> void:
	mouse_area[0] = false

	if not Global.efectos:
		$Inventario/Marcado.visible = false


func _on_area_2d_2_mouse_entered() -> void:
	$AudioStreamPlayer3.play()
	mouse_area[1] = true

	if not Global.efectos:
		$Inventario/Marcado2.visible = true


func _on_area_2d_2_mouse_exited() -> void:

	mouse_area[1] = false

	if not Global.efectos:
		$Inventario/Marcado2.visible = false


func _on_area_2d_3_mouse_entered() -> void:
	$AudioStreamPlayer3.play()
	mouse_area[2] = true

	if not Global.efectos:
		$Inventario/Marcado3.visible = true


func _on_area_2d_3_mouse_exited() -> void:

	mouse_area[2] = false

	if not Global.efectos:
		$Inventario/Marcado3.visible = false


func _on_area_2d_4_mouse_entered() -> void:
	$AudioStreamPlayer3.play()
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


func input_flecha(viewport,
	event,
	shape_idx
) -> void:

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				$AudioStreamPlayer4.play()
				get_tree().change_scene_to_file(
					"res://scenes/mapa.tscn"
				)
				Global.nivel += 1

func entrando_flecha() -> void:
	$AudioStreamPlayer3.play()
	$Sprite2D.material.set_shader_parameter(
		"glow_strength",
		1.5
	)

func saliendo_flecha() -> void:
	$Sprite2D.material.set_shader_parameter(
		"glow_strength",
		0
	)
