extends Area2D

# ==========================================
# 1. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	self.connect("body_entered", self, "_on_SuperPower1_body_entered")
	if has_node("Timer"):
		$Timer.connect("timeout", self, "_on_Timer_timeout")
	
func _on_SuperPower1_body_entered(body):
	# 1. El print de prueba: Nos dirá en la consola el nombre exacto de lo que lo tocó
	print("¡FÍSICAS FUNCIONANDO! El objeto que entró se llama: ", body.name)
	
	# 2. Buscamos al dueño de la función activar_modo_poderoso
	var objetivo = body
	
	# Si el cuerpo que entró no tiene la función, pero su padre sí (por la estructura de nodos):
	if not body.has_method("activar_modo_poderoso") and body.get_parent() and body.get_parent().has_method("activar_modo_poderoso"):
		objetivo = body.get_parent()
		
	# 3. Si encontramos la función en el cuerpo o en el padre, activamos el poder y lo borramos
	if objetivo.has_method("activar_modo_poderoso"):
		print("-> Activando modo poderoso en: ", objetivo.name)
		objetivo.activar_modo_poderoso()
		queue_free() # Borramos el poder SOLO AQUÍ, cuando ya terminó todo

# ==========================================
# 2. TEMPORIZADOR DE DESAPARICIÓN
# ==========================================
func _on_Timer_timeout():
	print("El superpoder expiró y desapareció del suelo.")
	queue_free()
