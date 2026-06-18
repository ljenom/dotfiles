# dotfiles

macOS system configuration — nix-darwin + Home Manager.

## Fresh Mac setup

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ljenom/dotfiles/main/scripts/bootstrap.sh)
```

## Rebuild after changes

```bash
darwin-rebuild switch --flake ~/.dotfiles
# or use the alias:
nrs
```

## Manual steps after bootstrap

| Tool | What to do |
|---|---|
| Raycast | Settings → Advanced → Import backup |
| BetterTouchTool | Preferences → Manage Presets → Import, re-enter license |
| Karabiner | Grant Input Monitoring in System Settings → Privacy & Security |
| ICE | Reconfigure menu bar item order manually |
| VS Code | Sign in to Settings Sync (GitHub) |

## Karabiner config

Copy `~/.config/karabiner/karabiner.json` into `home/karabiner.json`, then uncomment the symlink block in `home/home.nix`.
