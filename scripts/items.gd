extends Area2D

var mouse_encima = false
var offset = Vector2.ZERO
var moverse = false
var tiempo_pulsado = 0.0
var manteniendo_click = false
var mouse_boton = false

func _ready() -> void:
	$Label.visible = false
	$Button.visible = false

func _on_mouse_entered():
	mouse_encima = true
	$Timer.start()

func _on_mouse_exited():
	mouse_encima = false
	$Timer.stop()
	$Label.visible = false

func _on_button_pressed() -> void:
	if not Global.efectos:
		visible = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$Label.visible = false
			$Timer.stop()
			if not mouse_boton:
				$Button.visible = false
			if mouse_encima:
				if event.pressed and not Global.efectos:
					if self.name == "Node2D":
						Global.arrastrando[0] = true
					if self.name == "@Area2D@2":
						Global.arrastrando[1] = true
					if self.name == "@Area2D@3":
						Global.arrastrando[2] = true
					if self.name == "@Area2D@4":
						Global.arrastrando[3] = true
					moverse = true
					offset = global_position - get_global_mouse_position()
					manteniendo_click = true
					tiempo_pulsado = 0.0
			if not event.pressed:
				if self.name == "Node2D":
					Global.arrastrando[0] = false
				if self.name == "@Area2D@2":
					Global.arrastrando[1] = false
				if self.name == "@Area2D@3":
					Global.arrastrando[2] = false
				if self.name == "@Area2D@4":
					Global.arrastrando[3] = false
				if tiempo_pulsado < 0.2 and mouse_encima:
					$Button.visible = true
				if mouse_encima and not $Button.visible:
					$Timer.start()
				moverse = false
func _process(delta):
	if manteniendo_click:
		tiempo_pulsado += delta
	if moverse:
		z_index = 1
		global_position = get_global_mouse_position() + offset
	else:
		z_index = 0

func _on_timer_timeout() -> void:
	if not $Button.visible:
		$Label.visible = true


func _on_button_mouse_entered() -> void:
	mouse_boton = true


func _on_button_mouse_exited() -> void:
	mouse_boton = false
