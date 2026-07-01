# mac-bootstrap

One-command setup for a clean Mac dev foundation. Installs Homebrew, git + GitHub CLI,
`uv` (Python), `fnm` (Node), and VS Code with a minimal extension set — the same
foundation, no tech debt.

## Use it

```bash
git clone https://github.com/<owner>/mac-bootstrap.git
cd mac-bootstrap
bash setup.sh
```

The script is **idempotent** — safe to run more than once; it skips anything already installed.
It prompts for your name and email (for git), and leaves the two steps that need *you* to log in
(GitHub auth, VS Code sign-in) as clearly printed manual steps at the end.

## What you get

- **Homebrew** — one package manager for apps and tools.
- **uv** — modern Python: per-project isolated environments, no global `pip`, no polluted system Python.
- **fnm** — per-project Node versions.
- **VS Code** + Python / Ruff / ESLint extensions.
- A `~/dev` folder for all your code.

## After it runs

```bash
gh auth login          # connect your GitHub account
# then clone your projects into ~/dev
```

## Golden rules

- New Python project → `uv init`, then `uv add <pkg>`, `uv run`. Never `pip install` globally.
- New Node project → `fnm use`, then `npm install`.
- Keep code repos **out** of synced cloud folders (Dropbox/OneDrive/iCloud) — sync corrupts git.
- Install something new → it's already there next time; re-running the script won't hurt.
