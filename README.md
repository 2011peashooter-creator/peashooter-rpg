# PEASHOOTER RPG

Proyecto desarrollado con Godot 3.6.2.

## Versión web

Cada cambio enviado a la rama `main` ejecuta el workflow de GitHub Actions que
exporta el preset `Web` y publica el resultado en GitHub Pages. También se puede
ejecutar manualmente desde **Actions > Deploy Godot game to GitHub Pages > Run
workflow**.

Para activar el primer despliegue, abre **Settings > Pages** en GitHub y elige
**GitHub Actions** como fuente. Los siguientes despliegues serán automáticos.

Los presets existentes de Windows y Android se conservan. La exportación web usa
la plantilla sin hilos de Godot 3.6.2 para funcionar en GitHub Pages sin cabeceras
HTTP adicionales.
