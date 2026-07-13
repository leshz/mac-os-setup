#!/bin/bash

# =============================================================================
# SYNC
# Trae cambios de origin/main y aplica solo lo que cambió
# (brew tools/casks y/o dotfiles), sin correr el flujo completo de setup.sh
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="${SETUP_DIR}/dotfiles"

cd "$SETUP_DIR"

echo -e "${BLUE}Verificando actualizaciones en origin/main...${NC}"
git fetch --quiet origin main

BEHIND=$(git rev-list --count HEAD..origin/main)

if [[ "$BEHIND" -eq 0 ]]; then
    echo -e "${GREEN}✓ Ya estás al día con origin/main${NC}"
    mkdir -p "$HOME/.cache/mac-os-setup"
    date +%Y-%m-%d > "$HOME/.cache/mac-os-setup/last-check"
    exit 0
fi

echo -e "${YELLOW}Hay $BEHIND commit(s) nuevos en origin/main${NC}"

CHANGED_FILES=$(git diff --name-only HEAD origin/main)
echo -e "${BLUE}Archivos modificados:${NC}"
echo "$CHANGED_FILES" | sed 's/^/  • /'

echo -e "\n${BLUE}Actualizando repo (git pull)...${NC}"
git pull --quiet origin main
echo -e "${GREEN}✓ Repo actualizado${NC}"

# =============================================================================
# RE-EJECUTAR SOLO LO QUE CAMBIÓ
# =============================================================================

if echo "$CHANGED_FILES" | grep -qE "^scripts/01-homebrew\.sh$"; then
    echo -e "\n${BLUE}scripts/01-homebrew.sh cambió, re-ejecutando...${NC}"
    "$SCRIPT_DIR/01-homebrew.sh"
fi

if echo "$CHANGED_FILES" | grep -qE "^scripts/04-apps\.sh$"; then
    echo -e "\n${BLUE}scripts/04-apps.sh cambió, re-ejecutando...${NC}"
    "$SCRIPT_DIR/04-apps.sh"
fi

DOTFILES_CHANGED=$(echo "$CHANGED_FILES" | grep -E "^dotfiles/" || true)

if [[ -n "$DOTFILES_CHANGED" ]]; then
    echo -e "\n${BLUE}Dotfiles modificados, sincronizando al home...${NC}"

    backup_if_exists() {
        local file="$1"
        if [[ -f "$file" ]]; then
            local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$file" "$backup"
        fi
    }

    while IFS= read -r rel_path; do
        [[ -z "$rel_path" ]] && continue
        src="${SETUP_DIR}/${rel_path}"
        [[ -f "$src" ]] || continue

        case "$rel_path" in
            dotfiles/.zshrc)
                backup_if_exists "$HOME/.zshrc"
                cp "$src" "$HOME/.zshrc"
                echo -e "${GREEN}✓ .zshrc actualizado${NC}"
                ;;
            dotfiles/.gitconfig)
                backup_if_exists "$HOME/.gitconfig"
                cp "$src" "$HOME/.gitconfig"
                echo -e "${GREEN}✓ .gitconfig actualizado${NC}"
                ;;
            dotfiles/.gitignore_global)
                backup_if_exists "$HOME/.gitignore_global"
                cp "$src" "$HOME/.gitignore_global"
                echo -e "${GREEN}✓ .gitignore_global actualizado${NC}"
                ;;
            dotfiles/starship.toml)
                mkdir -p "$HOME/.config"
                backup_if_exists "$HOME/.config/starship.toml"
                cp "$src" "$HOME/.config/starship.toml"
                echo -e "${GREEN}✓ starship.toml actualizado${NC}"
                ;;
            dotfiles/bin/pick-editor)
                mkdir -p "$HOME/.local/bin"
                cp "$src" "$HOME/.local/bin/pick-editor"
                chmod +x "$HOME/.local/bin/pick-editor"
                echo -e "${GREEN}✓ pick-editor actualizado${NC}"
                ;;
            *)
                echo -e "${YELLOW}⚠ $rel_path cambió pero no tiene regla de sync, omitiendo${NC}"
                ;;
        esac
    done <<< "$DOTFILES_CHANGED"
fi

mkdir -p "$HOME/.cache/mac-os-setup"
date +%Y-%m-%d > "$HOME/.cache/mac-os-setup/last-check"

echo -e "\n${GREEN}✓ Sincronización completa${NC}"
echo -e "${YELLOW}Nota: reinicia el shell o corre 'zshreload' para aplicar cambios de .zshrc${NC}"
