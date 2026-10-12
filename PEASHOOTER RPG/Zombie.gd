extends KinematicBody2D

# ==========================================
# 1. VARIABLES DE CONFIGURACIÓN
# ==========================================
export (int) var velocidad = 150
export (int) var salud_maxima = 2

var salud_actual = salud_maxima
var movimiento = Vector2.ZERO

# ==========================================
# 2. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	salud_actual = salud_maxima
	
	if has_node("AreaDeteccion"):
		$AreaDeteccion.connect("body_entered", self, "_on_AreaDeteccion_body_entered")

func _physics_process(_delta):
	var jugador = global.jugador_actual
	
	if jugador and is_instance_valid(jugador):
		var direccion = (jugador.global_position - global_position).normalized()
		movimiento = direccion * velocidad
		movimiento = move_and_slide(movimiento)
		
		# Voltear sprite según movimiento horizontal
		if movimiento.x < 0:
			$Sprite.flip_h = false
		elif movimiento.x > 0:
			$Sprite.flip_h = true
	else:
		movimiento = Vector2.ZERO

# ==========================================
# 3. SISTEMA DE SALUD Y CONTROL DE BAJAS
# ==========================================
func recibir_danio(cantidad):
	salud_actual -= cantidad
	
	# Flash rojo de daño
	$Sprite.modulate = Color(1, 0.3, 0.3)
	yield(get_tree().create_timer(0.1), "timeout")
	if is_instance_valid(self):
		$Sprite.modulate = Color(1, 1, 1)
	
	if salud_actual <= 0:
		morir()

func morir():
	# COMUNICACIÓN CON EL MAPA: Avisa al script del nivel antes de ser borrado
	if get_parent() and get_parent().has_method("zombie_destruido"):
		get_parent().zombie_destruido()
		
	queue_free()

# ==========================================
# 4. DETECCIÓN DE COLISIONES (DAÑO AL JUGADOR)
# ==========================================
func _on_AreaDeteccion_body_entered(body):
	if body == global.jugador_actual:
		if body.has_method("recibir_golpe"):
			body.recibir_golpe()
