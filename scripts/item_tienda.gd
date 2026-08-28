extends Area2D

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false

# Posición original del objeto
var posicion_original = Vector2.ZERO

# Una vez que se agarra, queda bloqueado para siempre
var brillo_bloqueado = false


func _ready() -> void:

	posicion_original = position
	set_meta("posicion_tienda", position)


func _on_mouse_entered() -> void:

	mouse_encima = true

	# SOLO puede iluminarse si nunca ha sido agarrado
	if not brillo_bloqueado:

		if has_meta("indice_tienda"):

			var indice = get_meta("indice_tienda")

			Global.brillo[indice] = true


func _on_mouse_exited() -> void:

	mouse_encima = false

	# Si nunca ha sido agarrado, quitamos el brillo
	if not brillo_bloqueado:

		if has_meta("indice_tienda"):

			var indice = get_meta("indice_tienda")

			Global.brillo[indice] = false


func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if mouse_encima:

				if event.pressed:

					# =========================================
					# AGARRAR ITEM
					# =========================================

					# SE BLOQUEA PARA SIEMPRE
					brillo_bloqueado = true

					if has_meta("indice_tienda"):

						var indice = get_meta("indice_tienda")

						Global.brillo[indice] = false

					$Label.visible = false

					moverse = true

					offset = global_position - get_global_mouse_position()

				else:

					# =========================================
					# SOLTAR ITEM
					# =========================================

					moverse = false

					var inventario_encontrado = null

					# Buscamos si estamos encima de algún
					# objeto del inventario
					for item in Global.item:

						if not is_instance_valid(item):
							continue

						var distancia = global_position.distance_to(
							item.global_position
						)

						if distancia < 70:

							inventario_encontrado = item
							break


					# =========================================
					# INTERCAMBIO
					# =========================================

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

						# Si no se ha soltado encima de un objeto,
						# vuelve a su posición original.
						position = posicion_original

					# IMPORTANTE:
					# NO hacemos:
					#
					# brillo_bloqueado = false
					#
					# porque queremos que permanezca bloqueado
					# para siempre.


func _process(delta):

	if moverse:

		z_index = 1

		global_position = (
			get_global_mouse_position()
			+ offset
		)

	else:

		z_index = 0
