# Private Shell

[![asciicast](https://asciinema.org/a/768548.svg)](https://asciinema.org/a/768548)

A lightweight **incognito-style shell mode** for shared VMs and public environments.

Private shell is not about anonymity or sandboxing.  
It's about good operational hygiene when working on shared systems.

## Launch

### Default mode

```bash
curl -fsSL https://raw.githubusercontent.com/jazho76/private_shell/master/private_shell.sh \
  -o /tmp/private.sh && bash /tmp/private.sh && rm -f /tmp/private.sh
```

### Paranoid mode

```bash
curl -fsSL https://raw.githubusercontent.com/jazho76/private_shell/master/private_shell.sh \
  -o /tmp/private.sh && PARANOID=1  bash /tmp/private.sh && rm -f /tmp/private.sh
```

## What it does

It has two modes: default and paranoid.

### Default mode

When you start a private shell session:

- Shell history is kept in memory only (nothing is written to disk)
- Common tool histories are disabled (`less`, `python`, `node`, databases, `vim`, etc)
- Your normal shell configuration still works (AWS, kubectl, aliases, etc.)
- A visible `[private]` prompt indicator is added

This mode is non-invasive and suitable for everyday shared VM usage.

### Paranoid mode (opt-in)

When `PARANOID=1` is set, it additionally:

- Creates a temporary `$HOME` under `/tmp`
- Prevents reading any user dotfiles
- Disables in-memory shell history
- Cleans up the temporary home automatically on exit

This mode is stricter and intended for less trusted environments.
