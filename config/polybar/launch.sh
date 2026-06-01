#!/usr/bin/env bash

# Terminar las instancias de barra ya activas
killall -q polybar

# Esperar a que los procesos se cierren
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzar Polybar usando la configuración "main" que definimos antes
polybar main &

echo "Polybar lanzada..."
