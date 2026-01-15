#!/usr/bin/env bash
set -euo pipefail

umask 077

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
    echo -e "\e[1;36m[private]\e[0m cleaning up private home: $TMPHOME"
    case "$TMPHOME" in
      /tmp/private-home.*)
        rm -rf --one-file-system "$TMPHOME"
        ;;
    esac
  } 2>/dev/null || true
}
trap cleanup EXIT

export HOME="$TMPHOME"
export PS1='\[\e[1;36m\][private]\[\e[0m\] \[\e[33m\]\w\[\e[0m\] \$ '
cd "$HOME"

# history killers
export HISTFILE=/dev/null
export HISTSIZE=0
export HISTFILESIZE=0
export LESSHISTFILE=-
export MANPAGER='less -P ""'

export PYTHONHISTFILE=/dev/null
export NODE_REPL_HISTORY=/dev/null
export LUA_HISTORY=/dev/null
export IRBRC=/dev/null
export RUBYOPT='--disable=gems'

export PSQL_HISTORY=/dev/null
export MYSQL_HISTFILE=/dev/null
export SQLITE_HISTORY=/dev/null
export REDISCLI_HISTFILE=/dev/null

export VIMINIT='set viminfo='

echo -e "\e[1;36m[private]\e[0m HOME=$HOME"
echo -e "\e[1;36m[private]\e[0m exit shell to leave private mode"

bash --noprofile --norc
