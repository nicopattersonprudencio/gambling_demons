extends Node
 
var dinero = 10
var nivel = 1

#items
var arrastrando = [false,false,false,false]
var efectos = false
var instancia = preload("res://scenes/items.tscn")
var instancia_item = preload("res://scenes/items.tscn")

var item = [
	null,
	null,
	null,
	null
]

#items_tienda
var brillo = [false,false,false]
