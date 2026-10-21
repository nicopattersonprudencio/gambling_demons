extends Node2D

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
