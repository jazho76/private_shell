# Private Shell

A shell private-mode for shared VMs and public environments. This private shell gives you a clean, temporary session that leaves no personal traces behind.

It's not for anonymity or sandboxing.  
It's for good hygiene when using shared systems.

When you start a private shell session:

- A temporary `$HOME` is created under `/tmp`
- Shell history is disabled
- Common tool histories are disabled (`less`, `python`, `node`, databases, etc.)
- No user dotfiles are read
- When you exit, the temporary home is deleted

Think of it as an incognito mode for your terminal.

## Launch

```bash
curl -fsSL https://raw.githubusercontent.com/jazho76/private_shell/master/private_shell.sh -o /tmp/private.sh \
  && bash /tmp/private.sh \
  && rm -f /tmp/private.sh
```
