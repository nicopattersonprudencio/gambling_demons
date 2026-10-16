extends Node
 
var dinero = 12
var nivel = 1

#items
var arrastrando = [false,false,false,false]
var efectos = false
var instancia_item = preload("res://scenes/items.tscn")

var item = [
	instancia_item.instantiate(),
	instancia_item.instantiate(),
	instancia_item.instantiate(),
	instancia_item.instantiate()
]

#items_tienda
var brillo = [false,false,false]

# ============================================================
# READY
# ============================================================

func _ready() -> void:
	for i in range(item.size()):
		item[i].name = ["item-1", "item00", "item01", "item02"][i]

		add_child(item[i])
		item[i].visible = false

	item[0].set_meta("tipo_item", "rosa_roja")
	item[1].set_meta("tipo_item", "rosa_azul")
	item[2].set_meta("tipo_item", "boton_reinicio")
	item[3].set_meta("tipo_item", "candado_cerrado")
