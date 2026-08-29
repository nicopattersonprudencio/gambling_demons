extends Area2D


# ============================================================
# ESTADO DEL ITEM
# ============================================================

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false

# Posición original del objeto
var posicion_original = Vector2.ZERO

# Una vez pulsado, el brillo queda bloqueado para siempre
var brillo_bloqueado = false


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	posicion_original = position

	set_meta("posicion_cofre", position)

	# La descripción empieza oculta
	$Label.visible = false


# ============================================================
# MOUSE ENTERED
# ============================================================

func _on_mouse_entered() -> void:

	mouse_encima = true


	# ========================================================
	# MOSTRAR DESCRIPCIÓN
	# ========================================================

	$Label.visible = true


	# ========================================================
	# BRILLO
	# ========================================================

	# Si ya se ha pulsado, nunca vuelve a brillar
	if brillo_bloqueado:
		return

	$Sprite2D.material.set_shader_parameter(
		"glow_strength",
		0.5
	)


# ============================================================
# MOUSE EXITED
# ============================================================

func _on_mouse_exited() -> void:

	mouse_encima = false


	# ========================================================
	# OCULTAR DESCRIPCIÓN
	# ========================================================

	$Label.visible = false


	# ========================================================
	# BRILLO
	# ========================================================

	# Solo se quita temporalmente si todavía no se ha pulsado
	if not brillo_bloqueado:

		$Sprite2D.material.set_shader_parameter(
			"glow_strength",
			0
		)


# ============================================================
# INPUT
# ============================================================

func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if not mouse_encima:
				return


			# =================================================
			# CLICK
			# =================================================

			if event.pressed:

				# =============================================
				# BLOQUEAR BRILLO PARA SIEMPRE
				# =============================================

				brillo_bloqueado = true

				$Sprite2D.material.set_shader_parameter(
					"glow_strength",
					0
				)

				# Ocultar descripción mientras se arrastra
				$Label.visible = false


				# =============================================
				# COMENZAR A ARRASTRAR
				# =============================================

				moverse = true

				offset = (
					global_position
					- get_global_mouse_position()
				)


			# =================================================
			# SOLTAR
			# =================================================

			else:

				# Si no estaba siendo arrastrado, no hacemos nada
				if not moverse:
					return

				moverse = false

				var inventario_encontrado = null


				# =============================================
				# BUSCAR OBJETO DEL INVENTARIO
				# =============================================

				for item in Global.item:

					if not is_instance_valid(item):
						continue

					var distancia = global_position.distance_to(
						item.global_position
					)

					if distancia < 70:

						inventario_encontrado = item
						break


				# =============================================
				# INTERCAMBIO
				# =============================================

				if inventario_encontrado != null:

					var padre = get_parent()

					if padre.has_method(
						"intercambiar_item_cofre_con_inventario"
					):

						padre.intercambiar_item_cofre_con_inventario(
							self,
							inventario_encontrado
						)

				else:

					# No se ha soltado sobre ningún objeto
					position = posicion_original


# ============================================================
# PROCESS
# ============================================================

func _process(delta):

	if moverse:

		z_index = 1

		global_position = (
			get_global_mouse_position()
			+ offset
		)

	else:

		z_index = 0
