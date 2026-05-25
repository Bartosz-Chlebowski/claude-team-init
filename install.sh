#!/usr/bin/env bash
# install.sh — instalator skilla team-init
#
# Klonuje (lub aktualizuje) skill do ~/.claude/skills/team-init/
# i ustawia uprawnienia wykonywalne dla bash skryptu.
#
# Użycie:
#   curl -fsSL https://raw.githubusercontent.com/Bartosz-Chlebowski/claude-team-init/main/install.sh | bash
#
# lub po klonowaniu:
#   bash install.sh

set -euo pipefail

REPO_URL="https://github.com/Bartosz-Chlebowski/claude-team-init.git"
TARGET="$HOME/.claude/skills/team-init"

echo "════════════════════════════════════════════════════════════════════"
echo "  team-init — instalator skilla"
echo "════════════════════════════════════════════════════════════════════"
echo ""

# Sprawdź wymagania
command -v git >/dev/null 2>&1 || { echo "ERR: git nie zainstalowane" >&2; exit 1; }
command -v bash >/dev/null 2>&1 || { echo "ERR: bash nie zainstalowane" >&2; exit 1; }
command -v perl >/dev/null 2>&1 || { echo "ERR: perl nie zainstalowane" >&2; exit 1; }

# Katalog docelowy
mkdir -p "$HOME/.claude/skills"

if [[ -d "$TARGET/.git" ]]; then
  echo "📁 Skill już istnieje w $TARGET — aktualizuję (git pull)..."
  cd "$TARGET"
  git pull --quiet
  echo "  ✓ Zaktualizowane do najnowszej wersji"
elif [[ -d "$TARGET" ]]; then
  echo "⚠️  $TARGET istnieje, ale nie jest repo git."
  echo "    Zrób backup ręcznie i usuń katalog, zanim uruchomisz instalator."
  exit 1
else
  echo "⬇️  Klonuję $REPO_URL → $TARGET..."
  git clone --quiet "$REPO_URL" "$TARGET"
  echo "  ✓ Sklonowane"
fi

# Uprawnienia wykonywalne
chmod +x "$TARGET/setup-team.sh"
chmod +x "$TARGET/install.sh" 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "  ✅ ZAINSTALOWANE"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo "Skill team-init dostępny w $TARGET"
echo ""
echo "Jak używać:"
echo "  • W Claude Code: zrestartuj sesję i wpisz /team-init"
echo "  • Bezpośrednio z bash: bash $TARGET/setup-team.sh --help"
echo ""
echo "Aktualizacja w przyszłości: uruchom install.sh ponownie lub:"
echo "  cd $TARGET && git pull"
echo ""
