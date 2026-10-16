extends Area2D

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false
var tiempo_pulsado = 0.0
var manteniendo_click = false
var mouse_boton = false

func _ready() -> void:
	print(self.name)
	$Label.visible = false
	$Button.visible = false

func _on_mouse_entered():
	mouse_encima = true
	if not $Button.visible:
		$Label.visible = true

func _on_mouse_exited():
	mouse_encima = false
	$Label.visible = false

func _on_button_pressed() -> void:
	if not Global.efectos:
		$AudioStreamPlayer2.play()
		visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Label.visible = false
			if not mouse_boton:
				$Button.visible = false
			if mouse_encima:
				if event.pressed and not Global.efectos:
					print("ha llegado aqui")
					print(self.name)
					if self.name == "item-1":
						Global.arrastrando[0] = true
						print("se arrastra")
					if self.name == "item00":
						Global.arrastrando[1] = true
						print("se arrastra")
					if self.name == "item01":
						Global.arrastrando[2] = true
						print("se arrastra")
					if self.name == "item02":
						Global.arrastrando[3] = true
						print("se arrastra")
					moverse = true
					offset = global_position - get_global_mouse_position()
					manteniendo_click = true
					tiempo_pulsado = 0.0
			if not event.pressed:
				if self.name == "item-1":
					Global.arrastrando[0] = false
				if self.name == "item00":
					Global.arrastrando[1] = false
				if self.name == "item01":
					Global.arrastrando[2] = false
				if self.name == "item02":
					Global.arrastrando[3] = false
				if tiempo_pulsado < 0.2 and mouse_encima:
					$Button.visible = true
					$AudioStreamPlayer2.play()
				if mouse_encima and not $Button.visible:
					$Label.visible = true
				moverse = false
func _process(delta):
	if manteniendo_click:
		tiempo_pulsado += delta
	if moverse:
		z_index = 1
		global_position = get_global_mouse_position() + offset
	else:
		z_index = 0

func _on_button_mouse_entered() -> void:
	mouse_boton = true
	$AudioStreamPlayer.play()

func _on_button_mouse_exited() -> void:
	mouse_boton = false
