#!/bin/bash
# Prepara o disco persistente da Vertra e entrega para o script oficial do OpenBot.
set -euo pipefail
mkdir -p /app/data
export HOME=/app/data
exec /opt/OpenBot/app/resources/hosting/openbot-container
