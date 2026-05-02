#!/bin/bash

# =============================================================================
# DOTFILES SETUP
# Copia dotfiles personalizados al home directory
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Configurando dotfiles...${NC}"

# Obtener el directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_DIR="$(dirname "$SCRIPT_DIR")"
DOTFILES_DIR="${SETUP_DIR}/dotfiles"

echo -e "${BLUE}Directorio de dotfiles: $DOTFILES_DIR${NC}"

# =============================================================================
# BACKUP DE DOTFILES EXISTENTES
# =============================================================================

backup_if_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Creando backup: $backup${NC}"
        cp "$file" "$backup"
    fi
}

# =============================================================================
# COPIAR DOTFILES
# =============================================================================

echo -e "\n${BLUE}Copiando dotfiles...${NC}"

# .zshrc
if [[ -f "${DOTFILES_DIR}/.zshrc" ]]; then
    backup_if_exists "$HOME/.zshrc"
    cp "${DOTFILES_DIR}/.zshrc" "$HOME/.zshrc"
    echo -e "${GREEN}✓ .zshrc copiado${NC}"
else
    echo -e "${YELLOW}⚠ .zshrc no encontrado en dotfiles${NC}"
fi

# .gitconfig
if [[ -f "${DOTFILES_DIR}/.gitconfig" ]]; then
    backup_if_exists "$HOME/.gitconfig"
    cp "${DOTFILES_DIR}/.gitconfig" "$HOME/.gitconfig"
    echo -e "${GREEN}✓ .gitconfig copiado${NC}"
else
    echo -e "${YELLOW}⚠ .gitconfig no encontrado en dotfiles${NC}"
fi

# .gitignore_global
if [[ -f "${DOTFILES_DIR}/.gitignore_global" ]]; then
    backup_if_exists "$HOME/.gitignore_global"
    cp "${DOTFILES_DIR}/.gitignore_global" "$HOME/.gitignore_global"

    # Configurar Git para usar el gitignore global
    git config --global core.excludesfile ~/.gitignore_global

    echo -e "${GREEN}✓ .gitignore_global copiado y configurado${NC}"
else
    echo -e "${YELLOW}⚠ .gitignore_global no encontrado en dotfiles${NC}"
fi

# starship.toml
if [[ -f "${DOTFILES_DIR}/starship.toml" ]]; then
    # Crear directorio .config si no existe
    mkdir -p "$HOME/.config"

    backup_if_exists "$HOME/.config/starship.toml"
    cp "${DOTFILES_DIR}/starship.toml" "$HOME/.config/starship.toml"

    echo -e "${GREEN}✓ starship.toml copiado${NC}"
else
    echo -e "${YELLOW}⚠ starship.toml no encontrado en dotfiles${NC}"
fi

# ghostty/config
if [[ -f "${DOTFILES_DIR}/ghostty/config" ]]; then
    mkdir -p "$HOME/.config/ghostty"

    if [[ ! -f "$HOME/.config/ghostty/config" ]]; then
        cp "${DOTFILES_DIR}/ghostty/config" "$HOME/.config/ghostty/config"
        echo -e "${GREEN}✓ ghostty/config copiado${NC}"
    else
        echo -e "${GREEN}✓ ghostty/config ya existe, no se sobreescribe${NC}"
    fi
else
    echo -e "${YELLOW}⚠ ghostty/config no encontrado en dotfiles${NC}"
fi

# ghostty/shaders
if [[ -d "${DOTFILES_DIR}/ghostty/shaders" ]]; then
    mkdir -p "$HOME/.config/ghostty/shaders"
    cp -r "${DOTFILES_DIR}/ghostty/shaders/." "$HOME/.config/ghostty/shaders/"
    echo -e "${GREEN}✓ ghostty/shaders copiados${NC}"
else
    echo -e "${YELLOW}⚠ ghostty/shaders no encontrado en dotfiles${NC}"
fi

# ghostty/themes - descargar desde iTerm2-Color-Schemes
echo -e "\n${BLUE}Configurando temas de Ghostty...${NC}"

GHOSTTY_THEMES_DIR="$HOME/.config/ghostty/themes"
EXISTING_THEMES=$(ls "$GHOSTTY_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')

if [[ "$EXISTING_THEMES" -gt 10 ]]; then
    echo -e "${GREEN}✓ Temas de Ghostty ya instalados ($EXISTING_THEMES temas)${NC}"
else
    if command -v git &> /dev/null; then
        echo -e "${BLUE}Descargando temas de ghostty desde iterm2colorschemes.com...${NC}"
        TEMP_DIR=$(mktemp -d)

        git clone --depth=1 --filter=blob:none --sparse \
            https://github.com/mbadolato/iTerm2-Color-Schemes.git \
            "$TEMP_DIR/iterm2-schemes" 2>/dev/null

        cd "$TEMP_DIR/iterm2-schemes"
        git sparse-checkout set ghostty 2>/dev/null
        cd - > /dev/null

        if [[ -d "$TEMP_DIR/iterm2-schemes/ghostty" ]]; then
            mkdir -p "$GHOSTTY_THEMES_DIR"
            cp -r "$TEMP_DIR/iterm2-schemes/ghostty/." "$GHOSTTY_THEMES_DIR/"
            THEME_COUNT=$(ls "$GHOSTTY_THEMES_DIR" | wc -l | tr -d ' ')
            echo -e "${GREEN}✓ $THEME_COUNT temas de Ghostty instalados${NC}"
        else
            echo -e "${YELLOW}⚠ No se pudieron descargar los temas de Ghostty${NC}"
        fi

        rm -rf "$TEMP_DIR"
    else
        echo -e "${YELLOW}⚠ Git no disponible, no se pueden descargar temas${NC}"
    fi
fi

# =============================================================================
# CREAR ESTRUCTURA DE DIRECTORIOS
# =============================================================================

echo -e "\n${BLUE}Creando estructura de directorios...${NC}"

# Directorios comunes de desarrollo
mkdir -p "$HOME/Develop"
mkdir -p "$HOME/.config"

echo -e "${GREEN}✓ Directorios creados:${NC}"
echo -e "  • ~/Develop"
echo -e "  • ~/.config"

# =============================================================================
# CONFIGURAR SSH
# =============================================================================

echo -e "\n${BLUE}Configurando SSH...${NC}"

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Crear config de SSH si no existe
if [[ ! -f "$SSH_DIR/config" ]]; then
    cat > "$SSH_DIR/config" << 'EOF'
# SSH Config
# Add your SSH configurations here

# Example GitHub configuration:
# Host github.com
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/id_ed25519
#   AddKeysToAgent yes
#   UseKeychain yes

# Global settings
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentitiesOnly yes
EOF

    chmod 600 "$SSH_DIR/config"
    echo -e "${GREEN}✓ SSH config creado${NC}"
else
    echo -e "${GREEN}✓ SSH config ya existe${NC}"
fi

echo -e "\n${YELLOW}Para generar una nueva SSH key:${NC}"
echo -e "  ssh-keygen -t ed25519 -C \"tu@email.com\""
echo -e "  ssh-add --apple-use-keychain ~/.ssh/id_ed25519"

# =============================================================================
# RESUMEN
# =============================================================================

echo -e "\n${BLUE}=== Resumen de Dotfiles ===${NC}"
echo -e ""
echo -e "Archivos configurados:"
echo -e "  • ~/.zshrc (Zsh configuration)"
echo -e "  • ~/.gitconfig (Git configuration)"
echo -e "  • ~/.gitignore_global (Global Git ignore)"
echo -e "  • ~/.config/starship.toml (Starship prompt)"
echo -e "  • ~/.config/ghostty/config (Ghostty terminal)"
echo -e "  • ~/.config/nvim (LazyVim configuration)"
echo -e "  • ~/.ssh/config (SSH configuration)"
echo -e ""
echo -e "Directorios creados:"
echo -e "  • ~/Developer"
echo -e "  • ~/Projects"
echo -e "  • ~/.config"
echo -e ""

echo -e "${GREEN}✓ Dotfiles configurados${NC}"

# =============================================================================
# LAZYVIM SETUP
# =============================================================================

echo -e "\n${BLUE}=== Configurando LazyVim ===${NC}"

# Verificar si Neovim está instalado
if command -v nvim &> /dev/null; then
    NVIM_CONFIG_DIR="$HOME/.config/nvim"

    # Hacer backup de la configuración existente de Neovim si existe
    if [[ -d "$NVIM_CONFIG_DIR" ]]; then
        NVIM_BACKUP="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}Creando backup de Neovim config: $NVIM_BACKUP${NC}"
        mv "$NVIM_CONFIG_DIR" "$NVIM_BACKUP"
    fi

    # Clonar LazyVim starter
    echo -e "${BLUE}Clonando LazyVim starter...${NC}"
    git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"

    # Eliminar el directorio .git para que puedas hacer tu propio repo
    rm -rf "${NVIM_CONFIG_DIR}/.git"

    echo -e "${GREEN}✓ LazyVim instalado${NC}"
    echo -e "${YELLOW}Nota: LazyVim se configurará completamente la primera vez que ejecutes 'nvim'${NC}"
    echo -e "${YELLOW}Para abrir Neovim: nvim${NC}"
else
    echo -e "${RED}✗ Neovim no está instalado. Instálalo primero con 01-homebrew.sh${NC}"
fi

# =============================================================================
# INSTRUCCIONES PARA CREAR REPO DE DOTFILES
# =============================================================================

echo -e "\n${YELLOW}=== Crear Repositorio de Dotfiles ===${NC}"
echo -e ""
echo -e "Para respaldar tus dotfiles en un repositorio:"
echo -e ""
echo -e "1. Crea un repositorio en GitHub llamado 'dotfiles'"
echo -e ""
echo -e "2. Ejecuta estos comandos:"
echo -e "   ${BLUE}cd $SETUP_DIR${NC}"
echo -e "   ${BLUE}git init${NC}"
echo -e "   ${BLUE}git add .${NC}"
echo -e "   ${BLUE}git commit -m \"Initial dotfiles setup\"${NC}"
echo -e "   ${BLUE}git remote add origin git@github.com:TU_USUARIO/dotfiles.git${NC}"
echo -e "   ${BLUE}git push -u origin main${NC}"
echo -e ""
echo -e "3. En una Mac nueva, clona y ejecuta:"
echo -e "   ${BLUE}git clone git@github.com:TU_USUARIO/dotfiles.git${NC}"
echo -e "   ${BLUE}cd dotfiles${NC}"
echo -e "   ${BLUE}./setup.sh${NC}"
echo -e ""
