extends Area2D

func _ready():
	# Conectamos la colisión del área heredada
	if not is_connected("body_entered", self, "_on_PowerVida_body_entered"):
		self.connect("body_entered", self, "_on_PowerVida_body_entered")
	
	# Conectamos el Timer heredado para que desaparezca por tiempo limite (ej. 10 segundos)
	if has_node("Timer"):
		$Timer.connect("timeout", self, "_on_Timer_timeout")

func _on_DropVida_body_entered(body):
	# Detectamos al personaje (por su nodo físico 'cuerpo' o la instancia 'Lanzaguisantes')
	if body.name == "cuerpo" or body.name == "Lanzaguisantes":
		var objetivo = body
		
		# Si tu script de salud está en el Nodo2D raíz del personaje, buscamos al padre
		if not body.has_method("curar_vida") and body.get_parent() and body.get_parent().has_method("curar_vida"):
			objetivo = body.get_parent()
			
		# Si el objetivo tiene la función de curar, lo curamos y borramos el corazón del suelo
		if objetivo.has_method("curar_vida"):
			objetivo.curar_vida()
			queue_free() # Desaparece el objeto porque ya lo recogiste

func _on_Timer_timeout():
	print("El corazón de vida expiró y desapareció del suelo.")
	queue_free() # Se borra solo si el jugador no llegó a tiempo
