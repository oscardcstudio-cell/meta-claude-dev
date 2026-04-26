#!/usr/bin/env bash
# push-all-global.sh — push tous les repos git de l'ecosysteme Claude
# Usage : bash C:/dev/claude/push-all-global.sh
#
# Lance manuellement OU automatiquement (tache planifiee Windows toutes les 15min
# via push-all-global.vbs en wrapper silencieux).
#
# Comportement :
#   - Lock file dans %TEMP% — exit si un autre push tourne (sauf si lock > 14min = stale)
#   - Scanne tous les repos git connus (meta machine, buckets, sous-projets, user scope)
#   - Push uniquement si commits ahead (ne commit JAMAIS automatiquement)
#   - Logue dans C:/dev/claude/.push-all.log (rotation a 1000 lignes)
#   - Silencieux : utilise pour le mode auto. Pour le mode interactif, voir output a l'ecran.

set -u

LOCK_FILE="${TEMP:-/tmp}/push-all-claude.lock"
LOG_FILE="C:/dev/claude/.push-all.log"
LOCK_MAX_AGE_SECONDS=840  # 14 minutes (la tache tourne toutes les 15min)
LOG_MAX_LINES=1000

# Repos a scanner (paths absolus). Ordre : du plus general au plus specifique.
REPOS=(
  "C:/Users/oscar/.claude"
  "C:/dev/claude"
  "C:/dev/claude/studio_descartes"
  "C:/dev/claude/oscardcstudio"
)

# Sous-projets : on scanne automatiquement les dossiers contenant un .git
SCAN_DIRS=(
  "C:/dev/claude/studio_descartes"
  "C:/dev/claude/oscardcstudio"
)

# ---- Helpers ----
log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg"
  echo "$msg" >> "$LOG_FILE"
}

rotate_log() {
  if [ -f "$LOG_FILE" ]; then
    local lines
    lines=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
    if [ "$lines" -gt "$LOG_MAX_LINES" ]; then
      tail -n "$LOG_MAX_LINES" "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
  fi
}

cleanup_lock() {
  rm -f "$LOCK_FILE" 2>/dev/null
}

# ---- Lock ----
if [ -f "$LOCK_FILE" ]; then
  lock_age=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0)))
  if [ "$lock_age" -lt "$LOCK_MAX_AGE_SECONDS" ]; then
    log "SKIP — lock actif depuis ${lock_age}s (autre push en cours)"
    exit 0
  else
    log "WARN — lock stale (${lock_age}s) — on prend la main"
  fi
fi
echo "$$" > "$LOCK_FILE"
trap cleanup_lock EXIT

# ---- Scan auto des sous-repos ----
for scan_dir in "${SCAN_DIRS[@]}"; do
  [ -d "$scan_dir" ] || continue
  for sub in "$scan_dir"/*/; do
    if [ -d "${sub}.git" ]; then
      REPOS+=("${sub%/}")
    fi
  done
done

# ---- Push ----
log "===== Demarrage push-all-global ====="
pushed=0
clean=0
failed=0
skipped=0

for repo in "${REPOS[@]}"; do
  if [ ! -d "$repo/.git" ]; then
    log "  -- $repo : pas un repo git, skip"
    skipped=$((skipped+1))
    continue
  fi

  cd "$repo" || continue
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    log "  !! $repo ($branch) : pas d'upstream — skip"
    skipped=$((skipped+1))
    continue
  fi

  ahead=$(git rev-list --count "@{u}..HEAD" 2>/dev/null || echo "0")
  if [ "$ahead" -eq 0 ]; then
    clean=$((clean+1))
    continue
  fi

  log "  >> $repo ($branch) : push de $ahead commit(s)"
  if push_output=$(git push 2>&1); then
    log "     OK"
    pushed=$((pushed+1))
  else
    log "     FAIL : $(echo "$push_output" | head -3 | tr '\n' ' ')"
    failed=$((failed+1))
  fi
done

log "===== Termine : $pushed pushes / $clean clean / $skipped skip / $failed fail ====="
rotate_log
exit 0
