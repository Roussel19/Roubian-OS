#!/bin/bash
# Si quieres que cambie de color según el estado, podemos dejarlo simple primero:
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]; then
  echo ""  # Apagado (puedes cambiarlo a otro color si quieres)
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]; then
    echo ""  # Encendido pero sin dispositivos
  else
    echo ""  # Conectado
  fi
fi
