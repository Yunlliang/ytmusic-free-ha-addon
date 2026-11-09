#!/usr/bin/env bash
set -u
log(){ echo "[$(date -Iseconds)] $*"; }
docker info >/dev/null 2>&1 || { log "ERROR: Docker unavailable; disable Protection mode"; exit 1; }
mkdir -p /data/provider
AUTO_UPDATE=$(jq -r '.auto_update // false' /data/options.json 2>/dev/null || echo false)
get_upstream_sha(){
  curl -fsSL --connect-timeout 10 --max-time 30 -H 'Accept: application/vnd.github+json' \
    https://api.github.com/repos/sproft/ytmusic-free-provider/commits/main | jq -er '.sha | select(test("^[a-f0-9]{40}$"))'
}
fetch_provider(){
  local sha="${1:-}" temp folder
  if [ -z "$sha" ]; then sha=$(get_upstream_sha) || { log "Unable to resolve upstream revision"; return 1; }; fi
  temp=$(mktemp -d) || return 1
  if ! curl -fsSL --connect-timeout 15 --max-time 180 \
    "https://github.com/sproft/ytmusic-free-provider/archive/${sha}.tar.gz" -o "$temp/source.tar.gz" ||
     ! tar -xzf "$temp/source.tar.gz" -C "$temp"; then
    rm -rf "$temp"; log "Download failed"; return 1
  fi
  folder="$temp/ytmusic-free-provider-$sha/ytmusic_free"
  if [ ! -f "$folder/manifest.json" ]; then
    rm -rf "$temp"; log "Provider manifest missing"; return 1
  fi
  rm -rf /data/provider/ytmusic_free.new
  cp -a "$folder" /data/provider/ytmusic_free.new || { rm -rf "$temp"; return 1; }
  rm -rf /data/provider/ytmusic_free
  mv /data/provider/ytmusic_free.new /data/provider/ytmusic_free
  printf '%s\n' "$sha" > /data/provider/upstream.sha
  rm -rf "$temp"
  log "Cached upstream revision: $sha"
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
next_check=0
log "Starting YouTube Music Free watcher (auto_update=$AUTO_UPDATE)"
while true; do
  ma=$(find_ma)
  if [ -n "$ma" ]; then
    current=$(docker inspect --format '{{.Id}}' "$ma" 2>/dev/null || true)
    if [ -n "$current" ] && [ "$current" != "$last" ]; then
      if install "$ma"; then last="$current"; fi
    fi
    if [ "$AUTO_UPDATE" = "true" ] && [ "$(date +%s)" -ge "$next_check" ]; then
      next_check=$(( $(date +%s) + 86400 ))
      upstream=$(get_upstream_sha) || { log "Upstream check failed; retry in 24h"; upstream=""; }
      cached=$(cat /data/provider/upstream.sha 2>/dev/null || true)
      if [ -n "$upstream" ] && [ "$upstream" != "$cached" ]; then
        log "Upstream changed: ${cached:-unknown} -> $upstream"
        if fetch_provider "$upstream"; then
          if install "$ma"; then last="$current"; fi
        fi
      fi
    fi
  else
    last=""
  fi
  sleep 15
done
