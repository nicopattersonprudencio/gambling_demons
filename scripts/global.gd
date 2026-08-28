extends Node
 
var dinero = 7

#items
var arrastrando = [false,false,false,false]
var efectos = false
var instancia = preload("res://scenes/items.tscn")
var item = [instancia.instantiate(),instancia.instantiate(),instancia.instantiate(),instancia.instantiate()]

#items_tienda
var brillo = [false,false,false]
