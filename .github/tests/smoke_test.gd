extends SceneTree

const INTRO_SCENE = "res://Escenas/advertencia.tscn"
const MENU_SCENE = "res://Escenas/menu.tscn"
const MAP_SCENE = "res://Escenas/mapaprincipal.tscn"
const PLAY_BUTTON = "Icon2/boton_jugar"


func _init():
	call_deferred("_run")


func _fail(message):
	printerr("SMOKE_FAIL: ", message)
	quit(1)


func _run():
	var intro = ResourceLoader.load(INTRO_SCENE, "PackedScene")
	if intro == null:
		_fail("No se pudo importar la pantalla inicial")
		return

	var change_error = change_scene_to(intro)
	if change_error != OK:
		_fail("No se pudo abrir la pantalla inicial: error %s" % change_error)
		return

	yield(self, "idle_frame")
	yield(self, "idle_frame")
	if current_scene == null or current_scene.filename != INTRO_SCENE:
		_fail("La pantalla inicial no quedó activa")
		return
	print("SMOKE_PASS: pantalla inicial cargada")

	# advertencia.gd cambia al menú mediante su temporizador de 10 segundos.
	yield(create_timer(11.0), "timeout")
	yield(self, "idle_frame")
	if current_scene == null or current_scene.filename != MENU_SCENE:
		_fail("La pantalla inicial no pasó al menú")
		return
	print("SMOKE_PASS: pantalla inicial pasó al menú")

	var play_button = current_scene.get_node_or_null(PLAY_BUTTON)
	if play_button == null or not play_button.has_signal("pressed"):
		_fail("No se encontró el botón Jugar")
		return
	play_button.emit_signal("pressed")
	yield(self, "idle_frame")
	yield(self, "idle_frame")
	if current_scene == null or current_scene.filename != MAP_SCENE:
		_fail("El botón Jugar no abrió el mapa principal")
		return
	print("SMOKE_PASS: botón Jugar abrió el mapa principal")

	# Espera a que la primera oleada cree sus zombis.
	yield(create_timer(1.2), "timeout")
	var zombis = get_nodes_in_group("zombies")
	var primeros_atacantes = get_nodes_in_group("primer_zombie_atacante")
	if zombis.size() < 1:
		_fail("No apareció ningún zombi en la primera oleada")
		return
	if primeros_atacantes.size() != 1:
		_fail("Debe existir exactamente un primer zombi atacante especial")
		return

	var zombie_especial = primeros_atacantes[0]
	if not zombie_especial.has_node("PantalonBajado") or not zombie_especial.has_node("NalgaIzquierda"):
		_fail("El primer zombi no preparó la animación de pantalón y nalga")
		return

	var estado_global = get_root().get_node_or_null("global")
	var jugador = estado_global.jugador_actual if estado_global != null else null
	if jugador == null or not is_instance_valid(jugador):
		_fail("No se encontró al jugador para probar el ataque especial")
		return

	var vida_antes_del_ataque = jugador.vida_actual
	zombie_especial.global_position = jugador.global_position + Vector2(180, 0)
	yield(create_timer(0.7), "timeout")
	if not zombie_especial.get_node("NalgaIzquierda").visible:
		_fail("El primer zombi no mostró la nalga durante su ataque")
		return
	if get_nodes_in_group("proyectiles_caca").size() < 1:
		_fail("El primer zombi no lanzó el proyectil de caca")
		return
	print("SMOKE_PASS: primer zombi bajó el pantalón, mostró la nalga y lanzó caca")

	yield(create_timer(0.5), "timeout")
	if jugador.vida_actual != vida_antes_del_ataque - 1:
		_fail("El proyectil de caca no dañó al jugador")
		return
	print("SMOKE_PASS: el proyectil de caca dañó al jugador")

	# Mantiene el mapa activo brevemente para detectar errores de inicio.
	yield(create_timer(1.0), "timeout")
	print("SMOKE_PASS: ejecución básica completada sin errores bloqueantes")
	quit(0)
