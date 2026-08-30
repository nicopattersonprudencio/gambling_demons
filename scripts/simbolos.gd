extends Sprite2D


# ============================================================
# ESTADO
# ============================================================

var mouse_encima = false


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	# --------------------------------------------------------
	# MATERIAL PROPIO
	# --------------------------------------------------------

	if material:

		material = material.duplicate()


	# --------------------------------------------------------
	# CONECTAR SEÑALES DEL AREA2D
	# --------------------------------------------------------

	var area = $Area2D

	# --------------------------------------------------------
	# ASEGURAR QUE EL BRILLO EMPIEZA APAGADO
	# --------------------------------------------------------

	if material:

		material.set_shader_parameter(
			"glow_strength",
			0
		)

	# ========================================================
	# QUITAR BRILLO
	# ========================================================

	if material:

		material.set_shader_parameter(
			"glow_strength",
			0
		)


# ============================================================
# INPUT
# ============================================================

func _input(event):

	if not mouse_encima:
		return


	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if not event.pressed:
				return


			# =================================================
			# OBTENER TIPO
			# =================================================

			if not has_meta("tipo_simbolo"):

				print(
					"ERROR: El símbolo no tiene tipo."
				)

				return


			var tipo = get_meta("tipo_simbolo")


			# =================================================
			# CAMBIAR DE ESCENA
			# =================================================

			match tipo:

				"cofre":

					get_tree().change_scene_to_file(
						"res://scenes/cofre.tscn"
					)


				"demonio":

					get_tree().change_scene_to_file(
						"res://scenes/combate.tscn"
					)


				"dinero":

					get_tree().change_scene_to_file(
						"res://scenes/tienda.tscn"
					)


				_:

					print(
						"ERROR: Tipo de símbolo desconocido: ",
						tipo
					)

# ============================================================
# MOUSE ENTERED
# ============================================================

func _on_area_2d_mouse_entered() -> void:
	print("ha entrado")
	mouse_encima = true


	# ========================================================
	# BRILLO
	# ========================================================

	if material:

		material.set_shader_parameter(
			"glow_strength",
			1.5
		)

# ============================================================
# MOUSE EXITED
# ============================================================

func _on_area_2d_mouse_exited() -> void:
	mouse_encima = false
	print("ha salido")
	if material:

		material.set_shader_parameter(
			"glow_strength",
			0
		)
