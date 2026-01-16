#!/usr/bin/env bash
set -euo pipefail

umask 077

PARANOID_MODE=0
if [ -n "${PARANOID:-}" ]; then
  PARANOID_MODE=1
fi

CYAN='\e[1;36m'
GREY='\e[2m'
RESET='\e[0m'

log() {
  echo -e "${CYAN}[private]${RESET} ${GREY}$*${RESET}"
}

setup_temp_home() {
  TMPHOME="$(mktemp -d /tmp/private-home.XXXXXX)"

  case "$TMPHOME" in
    /tmp/private-home.*) ;;
    *)
      echo "Unsafe TMPHOME: $TMPHOME" >&2
      exit 1
      ;;
  esac

  cleanup() {
    {
      log "Cleaning up temporary HOME: $TMPHOME"
      rm -rf --one-file-system "$TMPHOME"
    } 2>/dev/null || true
  }
  trap cleanup EXIT

  export HOME="$TMPHOME"
  cd "$HOME" || exit 1
  log "Using temporary HOME directory: $TMPHOME"
}

run_default_mode() {
  log "In-disk shell history is disabled"
  log "Common tool histories are disabled"

  export PROMPT_COMMAND='PS1="\[\e[1;36m\][private]\[\e[0m\] \[\e[33m\]\w\[\e[0m\] \$ ";'"${PROMPT_COMMAND:-}"

  export HISTFILE=/dev/null
  export HISTFILESIZE=0
  export LESSHISTFILE=-
  export MANPAGER='less -P ""'

  export PYTHONHISTFILE=/dev/null
  export NODE_REPL_HISTORY=/dev/null
  export LUA_HISTORY=/dev/null
  export IRBRC=/dev/null

  export PSQL_HISTORY=/dev/null
  export MYSQL_HISTFILE=/dev/null
  export SQLITE_HISTORY=/dev/null
  export REDISCLI_HISTFILE=/dev/null

  export VIMINIT='set viminfo='
}

run_paranoid_mode() {
  log "In-memory shell history is disabled"
  log "No user dotfiles are read"

  export HISTSIZE=0
  export RUBYOPT='--disable=gems'

  setup_temp_home
}

if [ "$PARANOID_MODE" -eq 1 ]; then
  log "Running in PARANOID private mode"
else
  log "Running in DEFAULT private mode"
fi

run_default_mode

if [ "$PARANOID_MODE" -eq 1 ]; then
  run_paranoid_mode
fi

log "Exit shell to leave private mode"

if [ "$PARANOID_MODE" -eq 1 ]; then
  bash --noprofile --norc
else
  bash
fi

log "Exited private mode"
