#!/usr/bin/env bash
set -u
log(){ echo "[$(date -Iseconds)] $*"; }
docker info >/dev/null 2>&1 || { log "ERROR: Docker unavailable; disable Protection mode"; exit 1; }
mkdir -p /data/provider
fetch_provider(){
  local temp folder
  temp=$(mktemp -d)
  if ! curl -fsSL --connect-timeout 15 --max-time 180 https://github.com/sproft/ytmusic-free-provider/archive/refs/heads/main.tar.gz | tar -xz -C "$temp"; then
    rm -rf "$temp"; log "Download failed"; return 1
  fi
  folder="$temp/ytmusic-free-provider-main/ytmusic_free"
  if [ ! -f "$folder/manifest.json" ]; then
    rm -rf "$temp"; log "Provider manifest missing"; return 1
  fi
  rm -rf /data/provider/ytmusic_free
  cp -a "$folder" /data/provider/ytmusic_free
  rm -rf "$temp"
}
find_ma(){
  docker ps --format '{{.Names}}' | grep -E '^(app_|addon_).*music_assistant$' | head -n1 || true
}
install(){
  local ma="$1" dst
  dst=$(docker exec "$ma" sh -c 'for p in /app/venv/lib/python*/site-packages/music_assistant/providers; do if [ -d "$p" ]; then printf "%s" "$p"; exit 0; fi; done; exit 1' 2>/dev/null) || { log "Provider directory not found"; return 1; }
  [ -f /data/provider/ytmusic_free/manifest.json ] || fetch_provider || return 1
  docker cp /data/provider/ytmusic_free "$ma:$dst/" || return 1
  log "Provider installed in $ma"
  docker restart "$ma" >/dev/null && log "Music Assistant restarted"
}
last=""
log "Starting YouTube Music Free watcher"
while true; do
  ma=$(find_ma)
  if [ -n "$ma" ]; then
    current=$(docker inspect --format '{{.Id}}' "$ma" 2>/dev/null || true)
    if [ -n "$current" ] && [ "$current" != "$last" ]; then
      if install "$ma"; then last="$current"; fi
    fi
  else
    last=""
  fi
  sleep 15
done
