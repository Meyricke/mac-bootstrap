#!/bin/bash
# Mac dev bootstrap — a clean foundation for building things with code.
# Safe to re-run: every step checks before it installs.
# Installs: Homebrew, git + gh, uv (Python), fnm (Node), VS Code + core extensions.
#
# Run from this folder:  bash setup.sh

set -u
HERE="$(cd "$(dirname "$0")" && pwd)"

echo "==> 1/7  Xcode command line tools"
xcode-select -p >/dev/null 2>&1 || xcode-select --install

echo "==> 2/7  Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> 3/7  Brew packages (from Brewfile)"
brew bundle --file="$HERE/Brewfile"

echo "==> 4/7  Python (uv)"
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
uv python install 3.12

echo "==> 5/7  Node (fnm)"
grep -q 'fnm env' ~/.zshrc 2>/dev/null || \
  echo 'eval "$(fnm env --use-on-cd --shell zsh)"' >> ~/.zshrc
eval "$(fnm env --shell bash)"
fnm install --lts && fnm default lts-latest

echo "==> 6/7  Git identity"
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
  read -r -p "    Your name for git commits: " GIT_NAME
  read -r -p "    Your GitHub email: " GIT_EMAIL
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main
  git config --global pull.rebase false
else
  echo "    already set to: $(git config --global user.name)"
fi

echo "==> 7/7  VS Code extensions"
if command -v code >/dev/null 2>&1; then
  code --install-extension ms-python.python
  code --install-extension charliermarsh.ruff
  code --install-extension dbaeumer.vscode-eslint
else
  echo "    'code' not on PATH yet. Open VS Code once, run (Cmd-Shift-P)"
  echo "    'Shell Command: Install code command in PATH', then re-run this script."
fi

mkdir -p ~/dev

cat <<'DONE'

==> Foundation done. Two manual steps left (they need you to log in):
    1. gh auth login          # connect GitHub (GitHub.com -> HTTPS -> browser)
    2. In VS Code: sign in with GitHub + turn on Settings Sync

Then clone your projects into ~/dev and start building.
Golden rules: never global 'pip' (use 'uv add'); keep code out of synced cloud folders.
DONE
