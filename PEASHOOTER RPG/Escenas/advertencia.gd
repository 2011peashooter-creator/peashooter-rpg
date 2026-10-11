extends Node2D # O 'extends Node2D' según el tipo de nodo raíz que uses

# ==========================================
# 1. CONSTANTES Y RUTAS
# ==========================================
const ESCENA_MENU = "res://Escenas/menu.tscn"

# ==========================================
# 2. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	# se inicia la cuenta regresiva en lo que carga la pantalla
	iniciar_tiempo_espera()

# ==========================================
# 3. LÓGICA DE TEMPORIZADOR Y CAMBIO
# ==========================================
func iniciar_tiempo_espera():
	# Crea un temporizador interno que durará 10 segundos
	yield(get_tree().create_timer(10.0), "timeout")
	
	# Una vez pasados los 10 segundos, se cambiara a la escena del menú
	cambiar_al_menu()

func cambiar_al_menu():
	var directorio = Directory.new()
	if directorio.file_exists(ESCENA_MENU):
		get_tree().change_scene(ESCENA_MENU)
	else:
		print("ERROR: No se pudo encontrar la escena del menú en la ruta especificada: ", ESCENA_MENU)

# ==========================================
# 4. ENTRADAS (SALTAR INTRO)
# ==========================================
func _input(event):
	# Si el jugador presiona una tecla
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			# Saltamos directamente al menú sin esperar a que terminen los 10 segundos
			cambiar_al_menu()
