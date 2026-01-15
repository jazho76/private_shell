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
  case "$TMPHOME" in
    /tmp/private-home.*)
      rm -rf --one-file-system "$TMPHOME"
      ;;
  esac
}
trap cleanup EXIT

export HOME="$TMPHOME"

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

export INPUTRC=/dev/null
export NPM_CONFIG_USERCONFIG=/dev/null
export AWS_SHARED_CREDENTIALS_FILE=/dev/null
export AWS_CONFIG_FILE=/dev/null
export TF_CLI_CONFIG_FILE=/dev/null
export WGETRC=/dev/null

export VIMINIT='set viminfo='
export EMACS_USER_DIRECTORY="$HOME/.emacs.d"

echo "[private] HOME=$HOME"
echo "[private] exit shell to leave private mode"

if [ -t 0 ]; then
  exec bash --noprofile --norc
else
  exec bash --noprofile --norc -i < /dev/tty
fi
