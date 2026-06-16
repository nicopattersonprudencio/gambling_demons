extends Node2D

func _on_area_habilidad_mouse_entered() -> void:
	$Label6.visible = false
	$MarcadoHabilidades/marcado.visible = false
	if not Global.efectos:
		$Label6.visible = true
		$MarcadoHabilidades/marcado.visible = true
func _on_area_habilidad_mouse_exited() -> void:
	if not Global.efectos:
		$Label6.visible = false
		$MarcadoHabilidades/marcado.visible = false
