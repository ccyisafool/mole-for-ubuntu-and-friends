#!/usr/bin/env bash
# Install mo (Mole for Ubuntu).
#
# One-liner (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/ccyisafool/mole-for-ubuntu-and-friends/main/install.sh | bash
#
# From a git checkout:   ./install.sh        (symlinks the checkout, live-editable)
# Uninstall:             ./install.sh --uninstall
set -euo pipefail

REPO="ccyisafool/mole-for-ubuntu-and-friends"
INSTALL_DIR="${MOLE_INSTALL_DIR:-$HOME/.local/share/mole-ubuntu}"
BIN_DIR="${MOLE_BIN_DIR:-$HOME/.local/bin}"

if [[ "${1:-}" == "--uninstall" ]]; then
  rm -f "$BIN_DIR/mo"
  rm -rf "$INSTALL_DIR"
  echo "Removed $BIN_DIR/mo and $INSTALL_DIR"
  echo "(config in ~/.config/mole and logs in ~/.local/state/mole were kept)"
  exit 0
fi

src=""
script_dir="$(dirname "${BASH_SOURCE[0]:-}")"
if [[ -n "${BASH_SOURCE[0]:-}" && -f "$script_dir/mo" && -f "$script_dir/lib/core.sh" ]]; then
  # running from a checkout: symlink it directly (edits take effect immediately)
  src="$(cd "$script_dir" && pwd)"
else
  # running via curl|bash: fetch the latest tarball
  echo "Downloading $REPO ..."
  rm -rf "$INSTALL_DIR.tmp"
  mkdir -p "$INSTALL_DIR.tmp"
  curl -fsSL "https://github.com/$REPO/archive/refs/heads/main.tar.gz" \
    | tar -xz -C "$INSTALL_DIR.tmp" --strip-components=1
  rm -rf "$INSTALL_DIR"
  mv "$INSTALL_DIR.tmp" "$INSTALL_DIR"
  src="$INSTALL_DIR"
fi

chmod +x "$src/mo"
mkdir -p "$BIN_DIR"
ln -sf "$src/mo" "$BIN_DIR/mo"

echo "Installed: $BIN_DIR/mo -> $src/mo"
case ":$PATH:" in
  *:"$BIN_DIR":*) ;;
  *) echo "NOTE: $BIN_DIR is not on your PATH. Add:  export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac
echo "Try: mo --help"
