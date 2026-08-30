extends Node2D


# ============================================================
# ESCENA DE LOS SÍMBOLOS
# ============================================================

var instancia_simbolo = preload("res://scenes/simbolos.tscn")


# ============================================================
# SÍMBOLOS
# ============================================================

var simbolos = [
	instancia_simbolo.instantiate(),
	instancia_simbolo.instantiate(),
	instancia_simbolo.instantiate()
]


# ============================================================
# POSICIONES
# ============================================================

var posiciones_simbolos = [
	Vector2(0, -398),
	Vector2(-283, 283),
	Vector2(283, 283)
]


# ============================================================
# TIPOS DE SÍMBOLOS
# ============================================================

var tipos_simbolos = [
	"cofre",
	"demonio",
	"dinero"
]


# ============================================================
# DATOS DE LOS SÍMBOLOS
# ============================================================

var datos_simbolos = {

	"cofre": {
		"texture": preload("res://sprites/cofre_simbolo.png"),
		"scale": Vector2(0.3, 0.3)
	},

	"demonio": {
		"texture": preload("res://sprites/demonio_simbolo.png"),
		"scale": Vector2(0.5, 0.5)
	},

	"dinero": {
		"texture": preload("res://sprites/bolsa_dinero.png"),
		"scale": Vector2(0.15, 0.15)
	}
}


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	randomize()


	# ========================================================
	# CREAR LOS SÍMBOLOS
	# ========================================================

	for i in range(simbolos.size()):

		var simbolo = simbolos[i]


		# ----------------------------------------------------
		# POSICIÓN
		# ----------------------------------------------------

		simbolo.position = posiciones_simbolos[i]


		# ----------------------------------------------------
		# ELEGIR TIPO ALEATORIO
		# ----------------------------------------------------

		var tipo_seleccionado = tipos_simbolos.pick_random()


		# ----------------------------------------------------
		# OBTENER DATOS
		# ----------------------------------------------------

		var datos = datos_simbolos[tipo_seleccionado]


		# ----------------------------------------------------
		# SPRITE DEL SÍMBOLO
		# ----------------------------------------------------

		var sprite = simbolo.get_node("Sprite2D")

		sprite.texture = datos["texture"]
		sprite.scale = datos["scale"]


		# ----------------------------------------------------
		# GUARDAR TIPO
		# ----------------------------------------------------

		simbolo.set_meta(
			"tipo_simbolo",
			tipo_seleccionado
		)


		# ----------------------------------------------------
		# MATERIAL INDEPENDIENTE
		# ----------------------------------------------------

		if simbolo.material:

			simbolo.material = simbolo.material.duplicate()

		# ----------------------------------------------------
		# HACER INVISIBLE
		# ----------------------------------------------------

		simbolo.visible = false


		# ----------------------------------------------------
		# AÑADIR A LA ESCENA
		# ----------------------------------------------------

		add_child(simbolo)


		print(
			"Símbolo ",
			i,
			": ",
			tipo_seleccionado
		)


	# ========================================================
	# REPRODUCIR ANIMACIÓN
	# ========================================================

	$AnimationPlayer.play("inicio")


	# Esperar a que termine
	await $AnimationPlayer.animation_finished


	# ========================================================
	# HACER VISIBLES LOS SÍMBOLOS
	# ========================================================

	for simbolo in simbolos:

		if is_instance_valid(simbolo):

			simbolo.visible = true
