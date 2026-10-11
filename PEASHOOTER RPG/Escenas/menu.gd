extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_boton_jugar_pressed():
	get_tree().change_scene("res://Escenas/mapaprincipal.tscn")
	pass # Replace with function body.
