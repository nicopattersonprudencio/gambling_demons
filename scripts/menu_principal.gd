
extends Node2D

var boton_pulsado = false

"""General"""

var cantidad_efectos = 0
var realizar_efectos = true
var tiempo_entre_efectos = 1.0

const ESCENA_ITEM_OSCURO = preload("res://scenes/items_oscuros_menu.tscn")

# Objetos que están cayendo actualmente
var items_cayendo: Array[Dictionary] = []

# Límites de la caída
var velocidad_minima = 100.0
var velocidad_maxima = 300.0

var rotacion_minima = -3.0
var rotacion_maxima = 3.0

var intervalo_minimo = 0.15
var intervalo_maximo = 0.8

var margen_superior = 100.0
var margen_inferior = 150.0

@onready var todas_casillas = [
	$Sprite2D/casilla2D,
	$Sprite2D/casilla2D2,
	$Sprite2D/casilla2D5,
	$Sprite2D/casilla2D6,
	$Sprite2D/casilla2D9,
	$Sprite2D/casilla2D10,
	$Sprite2D/CasillaRoja,
	$Sprite2D/casilla2D3,
	$Sprite2D/casilla2D4,
	$Sprite2D/casilla2D7,
	$Sprite2D/casilla2D8,
	$Sprite2D/casilla2D11
]

@onready var casillas_modificandose = []

var datos_items = {
	"rosa_roja": {
		"texture": preload("res://sprites/rosa_roja.png"),
		"scale": Vector2(0.15, 0.15),
	},

	"rosa_azul": {
		"texture": preload("res://sprites/rosa_azul.png"),
		"scale": Vector2(0.15, 0.15),
	},

	"candado_cerrado": {
		"texture": preload("res://sprites/candado.png"),
		"scale": Vector2(0.3, 0.3),
	},

	"boton_reinicio": {
		"texture": preload("res://sprites/boton_reinicio.png"),
		"scale": Vector2(0.5, 0.45),
	},

	"regadera_dinero": {
		"texture": preload("res://sprites/regadera.png"),
		"scale": Vector2(0.2, 0.2),
	}
}


func _ready() -> void:
	randomize()

	# Iniciar la generación infinita de objetos
	generar_items_indefinidamente()


func _process(delta: float) -> void:
	"""Giro de la ruleta"""
	$Sprite2D.rotation += deg_to_rad(180) * delta

	"""Movimiento de los objetos que caen"""
	mover_items(delta)

	"""Generar efectos de las casillas"""
	if realizar_efectos:
		if todas_casillas.is_empty():
			return

		if todas_casillas.size() >= 4:
			cantidad_efectos = randi_range(1, 4)
		else:
			cantidad_efectos = randi_range(1, todas_casillas.size())

		for c in range(cantidad_efectos):
			var elegida = todas_casillas.pick_random()

			if elegida.texture == preload("res://sprites/casilla_roja.png"):
				elegida.get_node("rosa_azul2").emitting = true
			else:
				elegida.get_node("rosa_roja2").emitting = true

			todas_casillas.erase(elegida)
			casillas_modificandose.append(elegida)

		transformar_casillas()
		tiempo_espera()
		realizar_efectos = false


# ============================================================
# GENERACIÓN INFINITA DE OBJETOS
# ============================================================

func generar_items_indefinidamente() -> void:
	while is_inside_tree():
		crear_item_oscuro()

		# Intervalo aleatorio entre cada aparición
		var espera = randf_range(
			intervalo_minimo,
			intervalo_maximo
		)

		await get_tree().create_timer(espera).timeout


func crear_item_oscuro() -> void:
	# Elegir aleatoriamente un tipo de objeto
	var tipo_item = datos_items.keys().pick_random()
	var datos_item = datos_items[tipo_item]

	# Instanciar la escena
	var item = ESCENA_ITEM_OSCURO.instantiate() as Sprite2D

	if item == null:
		push_error("La escena items_oscuros_menu debe tener un Sprite2D como raíz.")
		return

	# IMPORTANTE: configurar el objeto ANTES de add_child()
	item.texture = datos_item["texture"]
	item.scale = datos_item["scale"]

	# Rotación inicial aleatoria
	item.rotation = randf_range(0.0, TAU)

	# Obtener los límites visibles de la cámara en coordenadas del mundo
	var transformacion = get_viewport().get_canvas_transform().affine_inverse()
	var esquina_superior = transformacion * Vector2.ZERO
	var esquina_inferior = transformacion * get_viewport_rect().size

	# Posición horizontal aleatoria
	var posicion_x = randf_range(
		esquina_superior.x,
		esquina_inferior.x
	)

	# Aparecer por encima de la cámara
	var posicion_y = esquina_superior.y - margen_superior

	# Velocidades aleatorias para este objeto
	var velocidad_caida = randf_range(
		velocidad_minima,
		velocidad_maxima
	)

	var velocidad_rotacion = randf_range(
		rotacion_minima,
		rotacion_maxima
	)

	# Añadir al árbol después de modificar sus propiedades
	add_child(item)

	# Posicionar en coordenadas globales
	item.global_position = Vector2(posicion_x, posicion_y)

	# Guardar sus datos de movimiento
	items_cayendo.append({
		"nodo": item,
		"velocidad": velocidad_caida,
		"rotacion": velocidad_rotacion,
		"limite_inferior": esquina_inferior.y + margen_inferior
	})


# ============================================================
# MOVIMIENTO Y ELIMINACIÓN
# ============================================================

func mover_items(delta: float) -> void:
	var transformacion = get_viewport().get_canvas_transform().affine_inverse()
	var limite_actual = (
		transformacion * get_viewport_rect().size
	).y + margen_inferior

	# Recorrer al revés para poder eliminar elementos sin problemas
	for i in range(items_cayendo.size() - 1, -1, -1):
		var datos = items_cayendo[i]
		var item: Sprite2D = datos["nodo"]

		# Eliminar referencias a nodos que ya no existen
		if not is_instance_valid(item):
			items_cayendo.remove_at(i)
			continue

		# Caída vertical
		item.global_position.y += datos["velocidad"] * delta

		# Giro constante durante la caída
		item.rotation += datos["rotacion"] * delta

		# Eliminar cuando salga por debajo de la cámara
		if item.global_position.y > limite_actual:
			item.queue_free()
			items_cayendo.remove_at(i)

# ============================================================
# EFECTOS DE LAS CASILLAS
# ============================================================

func transformar_casillas() -> void:
	await get_tree().create_timer(1.0).timeout

	for c in range(casillas_modificandose.size()):
		casillas_modificandose[c].get_node("rosa_roja2").emitting = false
		casillas_modificandose[c].get_node("rosa_azul2").emitting = false

		if casillas_modificandose[c].texture == preload("res://sprites/casilla_roja.png"):
			casillas_modificandose[c].texture = preload("res://sprites/casilla_azul.png")
		else:
			casillas_modificandose[c].texture = preload("res://sprites/casilla_roja.png")

		todas_casillas.append(casillas_modificandose[c])

	casillas_modificandose.clear()

func tiempo_espera() -> void:
	var tiempo = randf_range(1.0, 1.5)
	await get_tree().create_timer(tiempo).timeout
	realizar_efectos = true

func _on_button_5_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_5_pressed() -> void:
	if not boton_pulsado:
		boton_pulsado = true
		$AudioStreamPlayer2.play()
		Transicion.transition()
		await Transicion.on_transition_finished
		if not Global.tutorial_jugado:
			get_tree().change_scene_to_file(
							"res://scenes/spawn.tscn"
						)
		else:
			get_tree().change_scene_to_file(
							"res://scenes/mapa.tscn"
						)

func _on_button_6_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_6_pressed() -> void:
	$AudioStreamPlayer2.play()
	$Panel.visible = true
	$Label3.visible = true
	$Button8.visible = true
	$Label4.visible = true
	$Label5.visible = true
	$Label6.visible = true
	$Button5.visible = false
	$Button6.visible = false
	$Button7.visible = false
	$HSlider.visible = true
	$HSlider2.visible = true
	$HSlider3.visible = true

func _on_button_8_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_8_pressed() -> void:
	$AudioStreamPlayer2.play()
	$Panel.visible = false
	$Label3.visible = false
	$Button8.visible = false
	$Button5.visible = true
	$Button6.visible = true
	$Button7.visible = true
	$Label4.visible = false
	$Label5.visible = false
	$Label6.visible = false
	$HSlider.visible = false
	$HSlider2.visible = false
	$HSlider3.visible = false


func _on_button_7_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_7_pressed() -> void:
	$AudioStreamPlayer2.play()
	$Button5.visible = false
	$Button6.visible = false
	$Button7.visible = false
	$Panel.visible = true
	$Label7.visible = true
	$Label8.visible = true
	$Button9.visible = true
	$Button10.visible = true

func _on_button_10_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_10_pressed() -> void:
	$AudioStreamPlayer2.play()
	$Button5.visible = true
	$Button6.visible = true
	$Button7.visible = true
	$Panel.visible = false
	$Label7.visible = false
	$Label8.visible = false
	$Button9.visible = false
	$Button10.visible = false

func _on_button_9_mouse_entered() -> void:
	$AudioStreamPlayer.play()

func _on_button_9_pressed() -> void:
	$AudioStreamPlayer2.play()
	get_tree().quit()
