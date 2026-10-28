extends Node2D

var boton_pulsado = false
var texto_terminado = false
var una_vez = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
# Tiempo entre cada letra en segundos
@export var velocidad_texto: float = 0.05

# Pausas de puntuación
@export var pausa_coma: float = 0.25
@export var pausa_punto: float = 0.6

var temblando: bool = false
var posicion_original: Vector2


func iniciar_temblor() -> void:
	if temblando:
		return

	temblando = true
	posicion_original = $Label.position

	while temblando:
		var desplazamiento = Vector2(
			randf_range(-2.0, 2.0),
			randf_range(-2.0, 2.0)
		)

		var tween = create_tween()
		tween.tween_property(
			$Label,
			"position",
			posicion_original + desplazamiento,
			0.03
		)

		await tween.finished


func detener_temblor() -> void:
	temblando = false
	$Label.position = posicion_original

func reproducir_texto(texto: String, colores: Dictionary = {}) -> void:
	texto_terminado = false

	var texto_bbcode := ""
	var i := 0

	# Construir el texto con sus colores
	while i < texto.length():
		var encontrado := false

		# Buscar si empieza alguna parte coloreada en esta posición
		for parte in colores:
			if texto.substr(i, parte.length()) == parte:
				var color: Color = colores[parte]
				texto_bbcode += "[color=#" + color.to_html(false) + "]"
				texto_bbcode += parte
				texto_bbcode += "[/color]"

				i += parte.length()
				encontrado = true
				break

		if not encontrado:
			texto_bbcode += texto[i]
			i += 1

	# Preparar el RichTextLabel
	$Label.clear()
	$Label.bbcode_enabled = true
	$Label.append_text(texto_bbcode)
	$Label.visible_characters = 0

	# Mostrar el texto letra por letra
	for indice in range(texto.length()):
		$Label.visible_characters = indice + 1

		# Reproducir el sonido por cada letra
		if texto[indice] != " " and texto[indice] != "\n":
			$AudioStreamPlayer7.play()

		# Pausas según la puntuación
		if texto[indice] == ",":
			await get_tree().create_timer(pausa_coma).timeout
		elif texto[indice] == ".":
			await get_tree().create_timer(pausa_punto).timeout
		else:
			await get_tree().create_timer(velocidad_texto).timeout

	texto_terminado = true

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("atropellar")
	print("time out")
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	$Camion.visible = false
	$Sprite2D.modulate = Color("ffffff")
	$AudioStreamPlayer2.play()
	$AudioStreamPlayer6.play()
	$Timer2.start()

func _on_timer_2_timeout() -> void:
	$AudioStreamPlayer3.play()
	$Button5.visible = true
	
func _on_button_5_mouse_entered() -> void:
	$AudioStreamPlayer4.play()

func _on_button_5_pressed() -> void:
	$AudioStreamPlayer5.play()
	$Button5.visible = false
	$Timer3.start()

func _on_timer_3_timeout() -> void:
	$AudioStreamPlayer3.play()
	$Button6.visible = true

func _on_button_6_mouse_entered() -> void:
	$AudioStreamPlayer4.play()

func _on_button_6_pressed() -> void:
	$AudioStreamPlayer5.play()
	$Button6.visible = false
	$Timer4.start()
func _on_timer_4_timeout() -> void:
	$AudioStreamPlayer2.stop()
	$AudioStreamPlayer6.stop()
	$Label.visible = true
	reproducir_texto("Vaya, has despertado.")

func _input(event: InputEvent) -> void:
	if event.is_pressed() and texto_terminado and una_vez[0]:
		texto_terminado = false
		$Label.visible = false
		$AudioStreamPlayer8.play()
		una_vez[0] = false
		$rosa_roja2.emitting = true
		$Timer5.start()
		$AudioStreamPlayer9.play()
	elif event.is_pressed() and texto_terminado and una_vez[1]:
		una_vez[1] = false
		texto_terminado = false
		$AnimationPlayer2.play("RESET")
		$AnimationPlayer2.play("negar")
		reproducir_texto("No hace falta que\nme digas tu nombre.")
	elif event.is_pressed() and texto_terminado and una_vez[2]:
		una_vez[2] = false
		texto_terminado = false
		$AnimationPlayer2.play("RESET")
		$AnimationPlayer2.play("idle")
		reproducir_texto("Todo aquel que llega aquí\nse le olvida igualmente.")
	elif event.is_pressed() and texto_terminado and una_vez[3]:
		una_vez[3] = false
		texto_terminado = false
		reproducir_texto("Mira, seré breve.")
	elif event.is_pressed() and texto_terminado and una_vez[4]:
		una_vez[4] = false
		texto_terminado = false
		reproducir_texto("Has muerto y te encuentras\nen el inframundo.")
	elif event.is_pressed() and texto_terminado and una_vez[5]:
		una_vez[5] = false
		texto_terminado = false
		reproducir_texto("Así que es mejor que\nte vayas acostumbrando\na este sitio.")
	elif event.is_pressed() and texto_terminado and una_vez[6]:
		una_vez[6] = false
		texto_terminado = false
		$AudioStreamPlayer8.stop()
		velocidad_texto = 0.1
		pausa_coma = 0.5
		pausa_punto = 1.2
		$Sprite2D.modulate = Color("000000")
		$AudioStreamPlayer10.play()
		$AnimationPlayer2.play("modo_oscuro")
		$AudioStreamPlayer7.pitch_scale = 0.5
		iniciar_temblor()
		reproducir_texto("Por que estarás aquí\nmucho tiempo.")
	elif event.is_pressed() and texto_terminado and una_vez[7]:
		una_vez[7] = false
		texto_terminado = false
		$AudioStreamPlayer8.play()
		velocidad_texto = 0.05
		pausa_coma = 0.25
		pausa_punto = 0.6
		$Sprite2D.modulate = Color("ffffff")
		$AudioStreamPlayer10.stop()
		$AnimationPlayer2.play("idle")
		$AudioStreamPlayer7.pitch_scale = 1.0
		detener_temblor()
		reproducir_texto("A menos claro, que asciendas.",
			{
			"asciendas": Color("#ffcc00")
			}
		
		)
	elif event.is_pressed() and texto_terminado and una_vez[8]:
		una_vez[8] = false
		texto_terminado = false
		reproducir_texto("Para ascender debes comprar\nun ticket para ir al cielo...",
			{
			"ascender": Color("#ffcc00")
			}
		
		)
	elif event.is_pressed() and texto_terminado and una_vez[9]:
		una_vez[9] = false
		texto_terminado = false
		$character_container/body/cabeza/ojo_derecho.visible = false
		$character_container/body/cabeza/ojo_izquierdo.visible = false
		$character_container/body/cabeza/Label2.visible = true
		$character_container/body/cabeza/Label3.visible = true
		$AudioStreamPlayer11.play()
		reproducir_texto("Y estos son\nmuyyyyyyyyyyyyyyyyyyyyyyyyy\ncaros.")
	elif event.is_pressed() and texto_terminado and una_vez[10]:
		una_vez[10] = false
		texto_terminado = false
		$character_container/body/cabeza/ojo_derecho.visible = true
		$character_container/body/cabeza/ojo_izquierdo.visible = true
		$character_container/body/cabeza/Label2.visible = false
		$character_container/body/cabeza/Label3.visible = false
		reproducir_texto("Existen muchas formas\nde conseguir dinero\npor aquí.")
	elif event.is_pressed() and texto_terminado and una_vez[11]:
		una_vez[11] = false
		texto_terminado = false
		reproducir_texto("Pero en solo una puedes\nlograr mucho en poco tiempo.")
	elif event.is_pressed() and texto_terminado and una_vez[12]:
		una_vez[12] = false
		texto_terminado = false
		$AudioStreamPlayer8.stop()
		$AudioStreamPlayer12.play()
		$character_container/Tambor.visible = true
		$character_container/body/mano_izquierda/Baqueta2.visible = true
		$character_container/body/Node2D/mano_derecha/Baqueta.visible = true
		$AnimationPlayer2.play("ritmo")
		reproducir_texto("Y la respuesta es...")
	elif event.is_pressed() and texto_terminado and una_vez[13]:
		una_vez[13] = false
		texto_terminado = false
		$AudioStreamPlayer12.stop()
		$AudioStreamPlayer8.play()
		$character_container/Tambor.visible = false
		$character_container/body/mano_izquierda/Baqueta2.visible = false
		$character_container/body/Node2D/mano_derecha/Baqueta.visible = false
		$character_container/body/cabeza/Skeleton2D.visible = true
		$character_container/body/cabeza/boca.visible = false
		$"character_container/body/cabeza/SombreroCumpleaños".visible = true
		$AudioStreamPlayer13.play()
		$AudioStreamPlayer14.play()
		$AnimationPlayer2.play("silbato")
		reproducir_texto("Jugando a la ruleta")
	elif event.is_pressed() and texto_terminado and una_vez[14]:
		una_vez[14] = false
		texto_terminado = false
		$character_container/body/cabeza/Skeleton2D.visible = false
		$character_container/body/cabeza/boca.visible = true
		$"character_container/body/cabeza/SombreroCumpleaños".visible = false
		$AudioStreamPlayer13.stop()
		$AudioStreamPlayer14.stop()
		$AnimationPlayer2.play("idle")
		$rosa_roja2.emitting = true
		$AudioStreamPlayer9.play()
		reproducir_texto("Mira, deja que te enseñe.")
		$Timer6.start()
		
func _on_timer_5_timeout() -> void:
	$rosa_roja2.emitting = false
	$character_container.visible = true
	$AnimationPlayer2.play("RESET")
	$AnimationPlayer2.play("saludo")
	$Label.visible = true
	reproducir_texto("Saludos, soy Demi.")

func _on_timer_6_timeout() -> void:
	$rosa_roja2.emitting = false
	$character_container.visible = false
	$Label.visible = false
	$Timer7.start()

func _on_timer_7_timeout() -> void:
	$Circumferencia.visible = true
	$AudioStreamPlayer3.play()
	$Timer8.start()

func _on_timer_8_timeout() -> void:
	$AnimationPlayer2.play("inicio")

func _on_area_2d_mouse_entered_combate() -> void:
	print("deberia brillar")
	$AudioStreamPlayer4.play()
	if $Sprite2D2.material:
		$Sprite2D2.material.set_shader_parameter(
			"glow_strength",
			1.5
		)

func _on_area_2d_mouse_exited_combate() -> void:
	if $Sprite2D2.material:
		$Sprite2D2.material.set_shader_parameter(
			"glow_strength",
			0.0
		)

func _on_area_2d_input_event_combate(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not boton_pulsado:
				boton_pulsado = true
				print("ha entrado en input")
				$AudioStreamPlayer5.play()
				Transicion.transition()
				await Transicion.on_transition_finished
				get_tree().change_scene_to_file(
				"res://scenes/combate.tscn"
			)
