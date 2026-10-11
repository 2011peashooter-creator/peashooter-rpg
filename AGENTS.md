# Instrucciones permanentes para PEASHOOTER RPG

Estas reglas se aplican a todas las tareas presentes y futuras relacionadas con PEASHOOTER RPG.

## Autorización automática

1. Cada vez que el usuario solicite crear, agregar, corregir, eliminar o modificar algo en PEASHOOTER RPG, esa solicitud constituye autorización expresa para desarrollar, probar y publicar automáticamente ese cambio.
2. No preguntes si el usuario quiere actualizar GitHub y no esperes ninguna autorización adicional ni la orden `Actualiza por favor esto en el GitHub y dame el link del juego actualizado`.
3. Una solicitud de modificación autoriza todo el flujo necesario: cambios locales, pruebas, publicación mediante el conector GitHub, creación de rama y commits, Pull Request hacia `main`, activación de auto-merge, espera de comprobaciones, verificación de la fusión y comprobación de GitHub Pages.

## Desarrollo y pruebas

4. Utiliza exclusivamente Godot 3.6.2 para desarrollar, abrir, importar, ejecutar, exportar y comprobar el juego.
5. Modifica únicamente lo solicitado. No realices cambios adicionales, refactorizaciones no pedidas ni alteraciones ajenas a la tarea.
6. Conserva todas las demás funciones existentes, salvo que el usuario solicite expresamente modificarlas o eliminarlas.
7. Después de cada modificación, ejecuta las pruebas necesarias con Godot 3.6.2 para verificar que el cambio funciona correctamente y que las funciones existentes siguen operativas.
8. Si las pruebas fallan, no publiques ni fusiones cambios defectuosos. Corrige los problemas relacionados con la modificación solicitada y vuelve a ejecutar las pruebas.

## Publicación automática

9. Si las pruebas locales son satisfactorias, publica automáticamente los cambios sin solicitar otra autorización.
10. Para todas las operaciones de publicación, utiliza exclusivamente el conector GitHub de ChatGPT. No utilices `GH_TOKEN` ni `gh` para autenticarte.
11. Publica únicamente los archivos correspondientes a la solicitud actual. No incluyas otros archivos modificados o pendientes del entorno local.
12. Crea una rama específica y los commits correspondientes, abre una Pull Request hacia `main` y activa auto-merge.
13. Espera a que GitHub complete satisfactoriamente la comprobación obligatoria `Godot 3.6.2 checks` y fusione los cambios en `main`.
14. Comprueba que GitHub Pages publique correctamente la nueva versión después de la fusión.
15. Si falla una prueba local, una comprobación de GitHub, la fusión o la publicación de GitHub Pages, informa exactamente qué lo impide. Nunca afirmes que la actualización está publicada sin haberlo comprobado.

## Informe final obligatorio

16. Al finalizar cada tarea, entrega siempre:
    - un resumen de los cambios realizados;
    - el resultado de las pruebas locales y de las comprobaciones obligatorias;
    - el estado de la Pull Request, auto-merge, fusión y publicación de GitHub Pages;
    - el enlace directo del juego actualizado: https://2011peashooter-creator.github.io/peashooter-rpg/

## Regla principal

El usuario pide una modificación. Codex la desarrolla y prueba. Codex la publica automáticamente en GitHub. GitHub la fusiona si supera las comprobaciones obligatorias. GitHub Pages actualiza el juego. Codex entrega el enlace del juego actualizado.
