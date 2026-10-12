extends Node2D

# ==========================================
# 1. CONSTANTES Y CONFIGURACIÓN
# ==========================================
const ESCENA_ZOMBIE_NORMAL = preload("res://Escenas/Zombie.tscn")
const ESCENA_ZOMBIE_CONO   = preload("res://Escenas/ZombieCono.tscn")
const ESCENA_ZOMBIE_CUBO   = preload("res://Escenas/ZombieCubo.tscn")
const ESCENA_PODER_1 = preload("res://Escenas/SuperPower1.tscn")
const ESCENA_DROP_VIDA = preload("res://Escenas/PowerVida.tscn")

# Límites de la pantalla para la aparición aleatoria
const LIMITE_X_MIN = 50
const LIMITE_X_MAX = 950
const LIMITE_Y_MIN = 50
const LIMITE_Y_MAX = 550

# ==========================================
# 2. VARIABLES DEL SISTEMA DE OLEADAS
# ==========================================
var oleada_actual = 1
var zombies_por_crear = 5
var zombies_restantes_vivos = 0
var en_receso = false

# ==========================================
# 3. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	randomize()
	global.puntuacion_actual = 0
	actualizar_texto_interfaz()
	iniciar_oleada()
	
	# RESTAURADO: Enlazamos los clics físicos de los botones con sus funciones abajo
	if has_node("InterfazMapa/MenuPausa"):
		$InterfazMapa/MenuPausa/VBoxContainer/BotonReanudar.connect("pressed", self, "_on_BotonReanudar_pressed")
		$InterfazMapa/MenuPausa/VBoxContainer/BotonReiniciar.connect("pressed", self, "_on_BotonReiniciar_pressed")
		$InterfazMapa/MenuPausa/VBoxContainer/BotonMenu.connect("pressed", self, "_on_BotonMenu_pressed")
	if has_node("TiempoPoderes"):
		$TiempoPoderes.connect("timeout", self, "_on_TiempoPoderes_timeout")
		
# ==========================================
# 5. CAPTURA DE ENTRADAS (EVENTOS DE TECLADO)
# ==========================================
func _input(event):
	if event.is_action_pressed("pausar"):
		alternar_pausa()

# ===========================================
# 6. SECCION DE PODERES
# ==========================================
func _on_TiempoPoderes_timeout():
	# 1. Verificamos que el Sprite de tu área exista (Ajusta el nombre "AreaSpawnJugador" al real)
	if not has_node("zonaspawn"):
		print("ERROR: ¡No se encuentra el Sprite del área de spawn!")
		return
		
	# 2. Obtenemos el nodo del Sprite
	var sprite_area = $zonaspawn
	
	# 3. Almacenamos la posición central del Sprite en el mundo
	var centro_x = sprite_area.global_position.x
	var centro_y = sprite_area.global_position.y
	
	# 4. Calculamos la mitad del ancho y el alto del Sprite en píxeles
	# (Multiplicamos por el 'scale' por si escalaste o estiraste el Sprite en el editor)
	var mitad_ancho = (sprite_area.texture.get_size().x * sprite_area.scale.x) / 2
	var mitad_alto  = (sprite_area.texture.get_size().y * sprite_area.scale.y) / 2
	
	# 5. Definimos los límites matemáticos exactos DE ESA ÁREA
	var area_x_min = centro_x - mitad_ancho
	var area_x_max = centro_x + mitad_ancho
	var area_y_min = centro_y - mitad_alto
	var area_y_max = centro_y + mitad_alto
	
	# 6. Generamos la posición aleatoria RESTRINGIDA a esos límites
	var pos_x = rand_range(area_x_min, area_x_max)
	var pos_y = rand_range(area_y_min, area_y_max)
	
	# 7. Creamos el superpoder en esa posición exacta
	var poder_instancia = ESCENA_PODER_1.instance()
	poder_instancia.global_position = Vector2(pos_x, pos_y)
	add_child(poder_instancia)
	
	print("¡Superpoder generado cerca del jugador, dentro del área de spawn!")
# ==========================================
# 6. LÓGICA DEL MENÚ DE PAUSA
# ==========================================
func alternar_pausa():
	var nuevo_estado_pausa = !get_tree().paused
	get_tree().paused = nuevo_estado_pausa
	
	if has_node("InterfazMapa/MenuPausa"):
		$InterfazMapa/MenuPausa.visible = nuevo_estado_pausa

func _on_BotonReanudar_pressed():
	alternar_pausa()

func _on_BotonReiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_BotonMenu_pressed():
	get_tree().paused = false
	
	if has_node("InterfazMapa/MenuPausa"):
		get_tree().change_scene("res://Escenas/menu.tscn")

# ==========================================
# 7. LÓGICA DE LAS OLEADAS Y SPAWN
# ==========================================
func iniciar_oleada():
	en_receso = false
	zombies_por_crear = oleada_actual * 5
	zombies_restantes_vivos = zombies_por_crear
	actualizar_texto_interfaz()
	
	for _i in range(zombies_por_crear):
		if en_receso: 
			break
		seleccionar_y_generar_zombie()
		yield(get_tree().create_timer(0.2), "timeout")

func seleccionar_y_generar_zombie():
	var escena_a_instanciar = ESCENA_ZOMBIE_NORMAL
	var probabilidad = randf()
	
	if oleada_actual >= 5:
		if probabilidad < 0.10:
			escena_a_instanciar = ESCENA_ZOMBIE_CUBO 
		elif probabilidad < 0.35:
			escena_a_instanciar = ESCENA_ZOMBIE_CONO 
		else:
			escena_a_instanciar = ESCENA_ZOMBIE_NORMAL 
			
	elif oleada_actual >= 3:
		if probabilidad < 0.20:
			escena_a_instanciar = ESCENA_ZOMBIE_CONO
		else:
			escena_a_instanciar = ESCENA_ZOMBIE_NORMAL

	var zombie_instancia = escena_a_instanciar.instance()
	
	var pos_x = rand_range(LIMITE_X_MIN, LIMITE_X_MAX)
	var pos_y = rand_range(LIMITE_Y_MIN, LIMITE_Y_MAX)
	zombie_instancia.global_position = Vector2(pos_x, pos_y)
	
	add_child(zombie_instancia)

func proxima_oleada():
	en_receso = true
	oleada_actual += 1
	
	if has_node("InterfazMapa/TextoOleadas"):
		$InterfazMapa/TextoOleadas.text = "¡Oleada Completada! Siguiente en 3s..."
	
	yield(get_tree().create_timer(3.0), "timeout")
	iniciar_oleada()

# ==========================================
# 8. CONTROL DE ENEMIGOS E INTERFAZ
# ==========================================
func zombie_destruido():
	zombies_restantes_vivos -= 1
	global.puntuacion_actual += 100
	actualizar_texto_interfaz()
	
	if zombies_restantes_vivos <= 0 and not en_receso:
		proxima_oleada()

func actualizar_texto_interfaz():
	if has_node("InterfazMapa/TextoOleadas"):
		$InterfazMapa/TextoOleadas.text = "OLEADA: " + str(oleada_actual) + "  |  ZOMBIES: " + str(zombies_restantes_vivos)
	if has_node("InterfazMapa/TextoScore"):
		var score_formateado = "%08d" % global.puntuacion_actual
		$InterfazMapa/TextoScore.text = "SCORE:" + score_formateado

#esta es la función que se ejecuta cada vez que el Timer del mapa dice "¡Toca aparecer objeto!"
func _on_TimerSpawnObjetos_timeout():
	# 1. Elegimos una posición al azar en el mapa
	var posicion_al_azar = Vector2(rand_range(100, 900), rand_range(100, 500)) 
	
	# 2. Tiramos un número al azar entre 0 y 99
	var suerte = randi() % 100
	var nuevo_objeto
	
	# BALANCEO PERFECTO: 50% de probabilidad para cada uno
	if suerte < 50:
		nuevo_objeto = ESCENA_PODER_1.instance()
		print("Apareció un Poder Naranja (50% azar)")
	else:
		nuevo_objeto = ESCENA_DROP_VIDA.instance()
		print("Apareció un Corazón de Vida (50% azar)")
		
	# 3. Lo metemos al mapa y lo ubicamos en su posición
	add_child(nuevo_objeto)
	nuevo_objeto.global_position = posicion_al_azar
