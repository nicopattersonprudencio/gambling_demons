extends Area2D

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false

# Posición original del objeto
var posicion_original = Vector2.ZERO

# Indica si este objeto ya ha sido agarrado
var brillo_bloqueado = false


func _ready() -> void:
	# Guardamos la posición original
	posicion_original = position


func _on_mouse_entered() -> void:
	mouse_encima = true
	
	# El brillo solo se activa si todavía no ha sido agarrado
	if not brillo_bloqueado:
		
		if self.name == "@Area2D@5":
			Global.brillo[0] = true
		
		if self.name == "@Area2D@6":
			Global.brillo[1] = true
		
		if self.name == "@Area2D@7":
			Global.brillo[2] = true


func _on_mouse_exited() -> void:
	mouse_encima = false
	
	# Si no está bloqueado, quitamos el brillo
	if not brillo_bloqueado:
		
		if self.name == "@Area2D@5":
			Global.brillo[0] = false
		
		if self.name == "@Area2D@6":
			Global.brillo[1] = false
		
		if self.name == "@Area2D@7":
			Global.brillo[2] = false


func _input(event):
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			
			if mouse_encima:
				
				if event.pressed:
					
					# El objeto ha sido agarrado
					brillo_bloqueado = true
					
					# Quitar el brillo inmediatamente
					if self.name == "@Area2D@5":
						Global.brillo[0] = false
					
					if self.name == "@Area2D@6":
						Global.brillo[1] = false
					
					if self.name == "@Area2D@7":
						Global.brillo[2] = false
					
					# Ocultar descripción
					$Label.visible = false
					
					# Empezar a mover
					moverse = true
					
					offset = global_position - get_global_mouse_position()
				
				else:
					# Se ha soltado el botón izquierdo
					moverse = false
					
					# Volver a la posición original
					position = posicion_original


func _process(delta):
	if moverse:
		z_index = 1
		global_position = get_global_mouse_position() + offset
	else:
		z_index = 0
