extends Area2D

# Velocidad de la bala en píxeles por segundo
export (int) var velocidad = 500

# Vector que definirá la dirección del disparo
var direccion = Vector2.ZERO

func _ready():
	# Si la bala no choca con nada, se elimina sola en 5 segundos para no gastar memoria
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()

func _physics_process(delta):
	if direccion != Vector2.ZERO:
		# Al moverse a sí misma frame a frame, usa 'position'
		position += direccion * velocidad * delta

func _on_disparoguisante_body_entered(body):
	# Imprime en la consola el nombre de lo que chocó para investigar si falla
	print("La bala chocó con: ", body.name)
	
	if "zombie" in body.name.to_lower():
		if body.has_method("recibir_danio"):
			body.recibir_danio(1) # Le resta 1 de vida al zombie
		queue_free() # Destruye la bala de inmediato
	pass # Replace with function body.
