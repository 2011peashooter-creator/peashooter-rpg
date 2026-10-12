extends Area2D

export (float) var velocidad = 360.0
export (float) var tiempo_vida = 2.5

var direccion = Vector2.RIGHT


func _ready():
	add_to_group("proyectiles_caca")
	connect("body_entered", self, "_on_body_entered")
	update()


func configurar(nueva_direccion):
	direccion = nueva_direccion.normalized()
	if direccion == Vector2.ZERO:
		direccion = Vector2.RIGHT


func _physics_process(delta):
	global_position += direccion * velocidad * delta
	rotation += delta * 7.0
	tiempo_vida -= delta
	if tiempo_vida <= 0.0:
		queue_free()


func _on_body_entered(body):
	if body == global.jugador_actual and body.has_method("recibir_golpe"):
		body.recibir_golpe()
		queue_free()


func _draw():
	var marron_oscuro = Color(0.24, 0.10, 0.03)
	var marron = Color(0.43, 0.20, 0.05)
	var brillo = Color(0.68, 0.38, 0.10)
	draw_circle(Vector2(0, 4), 9.0, marron_oscuro)
	draw_circle(Vector2(-5, -3), 7.0, marron)
	draw_circle(Vector2(3, -7), 6.0, marron)
	draw_circle(Vector2(-3, -5), 2.0, brillo)
