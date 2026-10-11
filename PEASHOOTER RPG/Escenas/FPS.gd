extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	passextends Label

func _process(delta):
	# Engine.get_frames_per_second() obtiene los FPS actuales del motor
	# text cambia el contenido escrito en el Label
	text = "FPS: " + str(Engine.get_frames_per_second())
