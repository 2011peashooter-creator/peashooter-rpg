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

	# Mantiene el mapa activo brevemente para detectar errores de inicio.
	yield(create_timer(2.0), "timeout")
	print("SMOKE_PASS: ejecución básica completada sin errores bloqueantes")
	quit(0)
