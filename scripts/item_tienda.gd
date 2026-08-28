extends Area2D

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false

# Posición original del objeto
var posicion_original = Vector2.ZERO

# Una vez agarrado, el brillo queda bloqueado
var brillo_bloqueado = false


func _ready() -> void:

	posicion_original = position

	set_meta("posicion_tienda", position)


func _on_mouse_entered() -> void:

	mouse_encima = true

	# Si ya está vendido, nunca vuelve a iluminarse
	if brillo_bloqueado:
		return

	# Si todavía no está vendido, puede iluminarse
	if has_meta("indice_tienda"):

		var indice = get_meta("indice_tienda")

		if not get_parent().vendido[indice]:

			Global.brillo[indice] = true


func _on_mouse_exited() -> void:

	mouse_encima = false

	if has_meta("indice_tienda"):

		var indice = get_meta("indice_tienda")

		Global.brillo[indice] = false


func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if not mouse_encima:
				return


			# =================================================
			# CLICK
			# =================================================

			if event.pressed:

				var indice = get_meta("indice_tienda")


				# =============================================
				# TODAVÍA NO ESTÁ VENDIDO
				# =============================================

				if not get_parent().vendido[indice]:

					# Comprar el objeto
					get_parent().comprar_item(indice)

					# Si no se pudo comprar porque no había
					# suficiente dinero, no hacemos nada más.
					if not get_parent().vendido[indice]:
						return

					# Ya ha sido comprado.
					# No empezamos a arrastrarlo en este click.
					brillo_bloqueado = true
					Global.brillo[indice] = false

					return


				# =============================================
				# YA ESTÁ VENDIDO
				# =============================================

				brillo_bloqueado = true

				Global.brillo[indice] = false

				$Label.visible = false

				moverse = true

				offset = global_position - get_global_mouse_position()


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
						"intercambiar_item_tienda_con_inventario"
					):

						padre.intercambiar_item_tienda_con_inventario(
							self,
							inventario_encontrado
						)

				else:

					# No se ha soltado sobre ningún objeto
					position = posicion_original


				# IMPORTANTE:
				# NO ponemos brillo_bloqueado = false.
				#
				# Una vez comprado/agarrado, nunca vuelve
				# a iluminarse.


func _process(delta):

	if moverse:

		z_index = 1

		global_position = (
			get_global_mouse_position()
			+ offset
		)

	else:

		z_index = 0
