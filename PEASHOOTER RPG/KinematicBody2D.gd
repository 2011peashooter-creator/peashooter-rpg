extends KinematicBody2D

# ==========================================
# 1. CONSTANTES (PRELOADS)
# ==========================================
const BARRA_3_VIDAS = preload("res://Carpeta de Assets/Assets PeaRPG/Screenshot_34-removebg-preview.png")
const BARRA_2_VIDAS = preload("res://Carpeta de Assets/Assets PeaRPG/Screenshot_3-removebg-preview.png")
const BARRA_1_VIDA  = preload("res://Carpeta de Assets/Assets PeaRPG/Screenshot_5-removebg-preview.png")
const ESCENA_BALA = preload("res://Escenas/disparoguisante.tscn")
const TEXTURA_NORMAL = preload("res://Carpeta de Assets/Assets PeaRPG/personaje_simple-removebg-preview.png")
const TEXTURA_PODER_NARANJA = preload("res://Carpeta de Assets/Assets PeaRPG/guisanteenojado.png")

# ==========================================
# 2. VARIABLES GLOBALES DEL PERSONAJE
# ==========================================
export (int) var velocidad = 300

var vida_maxima = 3
var vida_actual = vida_maxima
var invulnerable = false
var movimiento = Vector2.ZERO
var ultima_direccion = Vector2.RIGHT # Inicializa mirando a la derecha
var esta_poderoso = false
var puede_disparar_automatico = true


# ==========================================
# 3. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	global.jugador_actual = self
	vida_actual = vida_maxima
	actualizar_interfaz_vida()
	
	# CORREGIDO: Se usa 'TimerPoder' con las mayúsculas correspondientes
	if has_node("timerpoder"):
		$timerpoder.connect("timeout", self, "desactivar_modo_poderoso")

func _process(delta):
	controlar_disparo()

func controlar_disparo():
	if esta_poderoso:
		# MODO PODEROSO: Solo con tener presionado (is_action_pressed)
		if Input.is_action_pressed("disparar") and puede_disparar_automatico:
			disparar()
			iniciar_cadencia_rapida()
	else:
		# MODO NORMAL: Hay que pulsar cada vez (is_action_just_pressed)
		if Input.is_action_just_pressed("disparar"):
			disparar()

# Control de velocidad del modo ráfaga
func iniciar_cadencia_rapida():
	puede_disparar_automatico = false
	# CORREGIDO: Se usa 'TimerCadencia' coordinado con el nodo
	if has_node("TimerCadencia"):
		$timercadencia.start()
		yield($timercadencia, "timeout")
	puede_disparar_automatico = true

# --- FUNCIONES DE ACTIVACIÓN (Llamadas desde el Drop) ---

func activar_modo_poderoso():
	esta_poderoso = true
	$Sprite.texture = TEXTURA_PODER_NARANJA 
	if has_node("timerpoder"):
		$timerpoder.start() 
	print("¡MODO NARANJA ACTIVADO!")

func desactivar_modo_poderoso():
	esta_poderoso = false
	$Sprite.texture = TEXTURA_NORMAL 
	print("El poder se ha agotado.")

func _physics_process(_delta): 
	obtener_input()
	
	# CORREGIDO: Se eliminó el "if Input disparar" duplicado que estaba aquí
	# para evitar el doble disparo por cada clic.
		
	# Realiza su movimiento físico en el mapa
	movimiento = move_and_slide(movimiento)

# ==========================================
# 4. MECÁNICAS DE MOVIMIENTO Y ACCIONES
# ==========================================
func obtener_input():
	movimiento = Vector2.ZERO
	var hubo_movimiento = false
	
	if Input.is_action_pressed("mover_hacia_la_derecha"):
		movimiento.x += 1
		$Sprite.flip_h = false
		hubo_movimiento = true
		
	if Input.is_action_pressed("mover_hacia_la_izquierda"):
		movimiento.x -= 1
		$Sprite.flip_h = true
		hubo_movimiento = true
		
	if Input.is_action_pressed("mover_hacia_abajo"):
		movimiento.y += 1
		hubo_movimiento = true
		
	if Input.is_action_pressed("mover_hacia_arriba"):
		movimiento.y -= 1
		hubo_movimiento = true
	
	movimiento = movimiento.normalized() * velocidad
	
	if hubo_movimiento:
		ultima_direccion = movimiento.normalized()

func disparar():
	var bala_instancia = ESCENA_BALA.instance()
	bala_instancia.direccion = ultima_direccion
	
	var posicion_boca = global_position + (ultima_direccion * 20)
	
	get_parent().add_child(bala_instancia)
	bala_instancia.global_position = posicion_boca
	bala_instancia.rotation = ultima_direccion.angle()

# ==========================================
# 5. SISTEMA DE SALUD E INTERFAZ
# ==========================================
func recibir_golpe():
	if invulnerable:
		return
		
	vida_actual -= 1
	invulnerable = true
	actualizar_interfaz_vida()
	
	if vida_actual <= 0:
		eliminar_jugador()
		return 
	
	$Sprite.modulate = Color(1, 0.3, 0.3)
	
	# CORREGIDO: Protección con un Timer seguro por si la escena cambia a mitad del proceso
	yield(get_tree().create_timer(0.5), "timeout")
	
	if is_instance_valid(self) and get_tree() != null:
		$Sprite.modulate = Color(1, 1, 1)
		invulnerable = false

func actualizar_interfaz_vida():
	if has_node("Interfaz/BarraVida"):
		$Interfaz/BarraVida.visible = true 
		
		if vida_actual == 3:
			$Interfaz/BarraVida.texture = BARRA_3_VIDAS
		elif vida_actual == 2:
			$Interfaz/BarraVida.texture = BARRA_2_VIDAS
		elif vida_actual == 1:
			$Interfaz/BarraVida.texture = BARRA_1_VIDA
		elif vida_actual <= 0:
			$Interfaz/BarraVida.visible = false

func eliminar_jugador():
	print("¡GAME OVER! El Lanzaguisantes fue destruido.")
	get_tree().change_scene("res://Escenas/menu.tscn")

# ==========================================
# NUEVA MECÁNICA: CURACIÓN
# ==========================================
func curar_vida():
	# Si ya tiene la vida llena (3), no hacemos nada
	if vida_actual >= vida_maxima:
		print("Vida ya está al máximo. ¡No se puede curar más!")
		return
		
	# Le sumamos 1 a la vida y actualizamos los corazones en pantalla
	vida_actual += 1
	actualizar_interfaz_vida()
	print("¡Jugador curado! Vida actual: ", vida_actual)
	
	# Efecto visual rápido: El personaje destella en verde por un instante
	$Sprite.modulate = Color(0.3, 1, 0.3) # Tinte verde
	yield(get_tree().create_timer(0.2), "timeout")
	if is_instance_valid(self):
		$Sprite.modulate = Color(1, 1, 1) # Vuelve a su color normal
