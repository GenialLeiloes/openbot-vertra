#!/bin/bash
# Prepara o disco persistente da Vertra e entrega para o script oficial do OpenBot.
# A Vertra deixa /run somente leitura para o usuario 1000, entao o runtime fica em /app/data/run.
set -euo pipefail
mkdir -p /app/data /app/data/run
chmod 700 /app/data/run 2>/dev/null || true
export HOME=/data
export XDG_RUNTIME_DIR=/app/data/run
export TMPDIR=/tmp
cd /data
exec /opt/OpenBot/app/resources/hosting/openbot-container
