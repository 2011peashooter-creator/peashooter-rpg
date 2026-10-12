extends KinematicBody2D

const ESCENA_PROYECTIL_CACA = preload("res://Escenas/ProyectilCaca.tscn")
const DISTANCIA_ATAQUE_CACA = 220.0
const TIEMPO_RECARGA_CACA = 2.4

# ==========================================
# 1. VARIABLES DE CONFIGURACIÓN
# ==========================================
export (int) var velocidad = 150
export (int) var salud_maxima = 2

var salud_actual = salud_maxima
var movimiento = Vector2.ZERO
var es_primer_atacante = false
var ataque_caca_en_curso = false
var ataque_caca_disponible = true

var pantalon_bajado = null
var nalga_izquierda = null
var nalga_derecha = null
var aviso_ataque = null

# ==========================================
# 2. FUNCIONES PRINCIPALES (CICLO DE VIDA)
# ==========================================
func _ready():
	salud_actual = salud_maxima
	add_to_group("zombies")

	if es_primer_atacante:
		add_to_group("primer_zombie_atacante")
		_crear_aspecto_ataque_caca()
	
	if has_node("AreaDeteccion"):
		$AreaDeteccion.connect("body_entered", self, "_on_AreaDeteccion_body_entered")

func _physics_process(_delta):
	var jugador = global.jugador_actual
	
	if jugador and is_instance_valid(jugador):
		var direccion = (jugador.global_position - global_position).normalized()

		if es_primer_atacante:
			if ataque_caca_en_curso:
				movimiento = Vector2.ZERO
				return
			if ataque_caca_disponible and global_position.distance_to(jugador.global_position) <= DISTANCIA_ATAQUE_CACA:
				_realizar_ataque_caca(jugador)
				return

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
		if es_primer_atacante:
			if ataque_caca_disponible and not ataque_caca_en_curso:
				_realizar_ataque_caca(body)
			return
		if body.has_method("recibir_golpe"):
			body.recibir_golpe()

# ==========================================
# 5. ATAQUE ESPECIAL DEL PRIMER ZOMBI
# ==========================================
func _crear_aspecto_ataque_caca():
	pantalon_bajado = Polygon2D.new()
	pantalon_bajado.name = "PantalonBajado"
	pantalon_bajado.polygon = PoolVector2Array([
		Vector2(-18, 5), Vector2(18, 5), Vector2(15, 17), Vector2(-15, 17)
	])
	pantalon_bajado.color = Color(0.08, 0.18, 0.42)
	pantalon_bajado.z_index = 4
	pantalon_bajado.visible = false
	add_child(pantalon_bajado)

	nalga_izquierda = _crear_nalga("NalgaIzquierda", Vector2(-7, 7))
	nalga_derecha = _crear_nalga("NalgaDerecha", Vector2(7, 7))

	aviso_ataque = Label.new()
	aviso_ataque.name = "AvisoAtaqueCaca"
	aviso_ataque.rect_position = Vector2(-78, -72)
	aviso_ataque.rect_size = Vector2(156, 24)
	aviso_ataque.align = Label.ALIGN_CENTER
	aviso_ataque.add_color_override("font_color", Color(0.35, 0.16, 0.02))
	aviso_ataque.add_color_override("font_outline_modulate", Color(1, 1, 1))
	aviso_ataque.add_constant_override("outline_size", 2)
	aviso_ataque.z_index = 5
	aviso_ataque.visible = false
	add_child(aviso_ataque)

func _crear_nalga(nombre, centro):
	var nalga = Polygon2D.new()
	nalga.name = nombre
	var puntos = PoolVector2Array()
	for indice in range(20):
		var angulo = TAU * float(indice) / 20.0
		puntos.append(centro + Vector2(cos(angulo), sin(angulo)) * 10.0)
	nalga.polygon = puntos
	nalga.color = Color(0.55, 0.72, 0.42)
	nalga.z_index = 3
	nalga.visible = false
	add_child(nalga)
	return nalga

func _realizar_ataque_caca(jugador):
	if ataque_caca_en_curso or not ataque_caca_disponible:
		return

	ataque_caca_en_curso = true
	ataque_caca_disponible = false
	movimiento = Vector2.ZERO

	var orientacion_original = $Sprite.flip_h
	$Sprite.flip_h = not orientacion_original
	$Sprite.modulate = Color(0.78, 0.92, 0.68)

	pantalon_bajado.visible = true
	pantalon_bajado.position = Vector2(0, 4)
	aviso_ataque.text = "¡SE BAJA EL PANTALÓN!"
	aviso_ataque.visible = true

	yield(get_tree().create_timer(0.25), "timeout")
	if not is_instance_valid(self):
		return

	pantalon_bajado.position = Vector2(0, 17)
	nalga_izquierda.visible = true
	nalga_derecha.visible = true
	aviso_ataque.text = "¡MUESTRA LA NALGA!"

	yield(get_tree().create_timer(0.35), "timeout")
	if not is_instance_valid(self):
		return

	if jugador and is_instance_valid(jugador):
		_lanzar_proyectil_caca(jugador)
	aviso_ataque.text = "¡ATAQUE DE CACA!"

	yield(get_tree().create_timer(0.25), "timeout")
	if not is_instance_valid(self):
		return

	pantalon_bajado.visible = false
	nalga_izquierda.visible = false
	nalga_derecha.visible = false
	aviso_ataque.visible = false
	$Sprite.flip_h = orientacion_original
	$Sprite.modulate = Color(1, 1, 1)
	ataque_caca_en_curso = false

	yield(get_tree().create_timer(TIEMPO_RECARGA_CACA), "timeout")
	if is_instance_valid(self):
		ataque_caca_disponible = true

func _lanzar_proyectil_caca(jugador):
	var direccion = (jugador.global_position - global_position).normalized()
	if direccion == Vector2.ZERO:
		direccion = Vector2.RIGHT

	var proyectil = ESCENA_PROYECTIL_CACA.instance()
	get_parent().add_child(proyectil)
	proyectil.global_position = global_position + direccion * 30.0
	proyectil.configurar(direccion)
