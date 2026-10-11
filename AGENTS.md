# Instrucciones permanentes para PEASHOOTER RPG

Estas reglas se aplican a todas las tareas que modifiquen PEASHOOTER RPG.

## Modificación y pruebas

1. Utiliza exclusivamente Godot 3.6.2 para desarrollar, abrir, importar, ejecutar, exportar y probar el juego.
2. Conserva todas las funciones existentes, salvo que el usuario solicite expresamente modificarlas o eliminarlas.
3. Modifica solamente lo solicitado. No realices cambios adicionales, refactorizaciones no pedidas ni alteraciones de configuración ajenas a la tarea.
4. Después de cada modificación, ejecuta las pruebas necesarias con Godot 3.6.2 para comprobar que el cambio funciona y que las funciones existentes siguen operativas.
5. Al terminar, informa claramente:
   - qué archivos y comportamientos se modificaron;
   - qué pruebas se ejecutaron;
   - cuáles fueron sus resultados;
   - cualquier fallo, limitación o riesgo pendiente.

## Prohibición de publicación sin autorización

6. No publiques automáticamente ninguna modificación en GitHub.
7. No crees ramas, commits ni Pull Requests, no fusiones cambios y no actives auto-merge sin autorización expresa del usuario.
8. Una solicitud para modificar el juego nunca constituye autorización para publicarlo.
9. Después de modificar y probar, detente y espera la autorización del usuario.
10. La única orden que autoriza la publicación es exactamente:

   > Actualiza por favor esto en el GitHub y dame el link del juego actualizado

11. Si la orden no coincide exactamente, no publiques y solicita confirmación.

## Flujo autorizado de publicación

12. Únicamente después de recibir la orden exacta de autorización:
    - utiliza exclusivamente el conector GitHub de ChatGPT para publicar;
    - no utilices `GH_TOKEN` ni `gh` para autenticarte;
    - crea una rama específica para los cambios;
    - crea los commits correspondientes;
    - abre una Pull Request hacia `main`;
    - activa auto-merge;
    - espera a que GitHub complete la comprobación obligatoria `Godot 3.6.2 checks`;
    - verifica que todas las comprobaciones obligatorias sean satisfactorias;
    - verifica que la Pull Request se haya fusionado correctamente;
    - verifica que GitHub Pages haya publicado la nueva versión;
    - entrega el enlace directo para abrir y jugar la versión actualizada.
13. Si falla una prueba, una comprobación de GitHub, la fusión o la publicación en GitHub Pages, informa del problema y no afirmes que el juego está actualizado.

## Conservación de cambios pendientes

14. Mientras no exista autorización, conserva los cambios únicamente en el entorno local y no los publiques.
15. Si los cambios pendientes no pueden conservarse con seguridad entre tareas o sesiones, avisa al usuario antes de finalizar y explica cómo guardarlos sin publicarlos.

## Regla principal

Tú modificas y pruebas. El usuario revisa y autoriza. Solo después de la autorización exacta publicas en GitHub y entregas el enlace del juego actualizado.
