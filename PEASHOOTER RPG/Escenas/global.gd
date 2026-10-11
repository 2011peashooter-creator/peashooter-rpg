extends Node

# ==========================================
# 1. VARIABLES GLOBALES DEL JUEGO
# ==========================================
var jugador_actual = null
var puntuacion_actual = 0 # Aquí se guardará el score acumulado

# ==========================================
# 2. FUNCIONES DE CONTROL
# ==========================================
func reiniciar_juego():
	puntuacion_actual = 0
