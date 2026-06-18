#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/ljenom/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  macOS bootstrap — $(date)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! xcode-select -p &>/dev/null; then
  echo "→ Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "  Re-run this script after the CLT installer finishes."
  exit 0
fi

if ! command -v nix &>/dev/null; then
  echo "→ Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "✓ Nix already installed"
fi

if [ ! -d "$DOTFILES_DIR" ]; then
  echo "→ Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  echo "✓ Dotfiles already at $DOTFILES_DIR"
  git -C "$DOTFILES_DIR" pull
fi

# NVM is installed via Homebrew (triggered by nix-darwin homebrew.brews)
# After darwin-rebuild, activate it and install LTS node


echo "→ Applying nix-darwin configuration..."
cd "$DOTFILES_DIR"
nix run nix-darwin -- switch --flake ".#Leons-MacBook-Pro-2"

# Activate NVM (installed via Homebrew above) and install LTS node
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
if command -v nvm &>/dev/null; then
  echo "→ Installing Node LTS via NVM..."
  nvm install --lts
  nvm alias default node
fi

echo "→ Registering JDKs with jenv..."
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
for jdk in /Library/Java/JavaVirtualMachines/*/Contents/Home; do
  jenv add "$jdk" 2>/dev/null || true
done
jenv global 21 2>/dev/null || true

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "→ Generating SSH key..."
  read -rp "  Email for SSH key: " ssh_email
  ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"
  echo ""
  echo "  Add this public key to GitHub → Settings → SSH keys:"
  cat "$HOME/.ssh/id_ed25519.pub"
  read -rp "  Press Enter once added..."
else
  echo "✓ SSH key already exists"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Done! Manual steps remaining:"
echo "  1. Raycast   → Settings → Advanced → Import backup"
echo "  2. BTT       → Preferences → Manage Presets → Import"
echo "  3. Karabiner → grant Input Monitoring in System Settings → Privacy"
echo "  4. ICE       → reconfigure menu bar order"
echo "  5. VS Code   → sign in to Settings Sync"
echo "  6. Atuin     → run: atuin login (to sync shell history)"
echo "  7. AWS/npm   → run: ds-login (CodeArtifact auth)"
echo "  8. GCP/npm   → run: do-login (Artifact Registry auth)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
