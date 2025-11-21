#!/bin/bash

# =============================================================================
# APPLICATIONS SETUP
# Instala VSCode, Cursor, OrbStack y fuentes Nerd Fonts
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Instalando aplicaciones...${NC}"

# =============================================================================
# APLICACIONES GUI (CASKS)
# =============================================================================

echo -e "\n${BLUE}=== Aplicaciones GUI ===${NC}"

# Array de aplicaciones
APPS=(
    "visual-studio-code"    # VSCode
    "cursor"                # Cursor Editor
    "orbstack"              # OrbStack (Docker/Linux alternative)
)

for app in "${APPS[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        echo -e "${GREEN}✓ $app ya está instalado${NC}"
    else
        echo -e "${BLUE}Instalando $app...${NC}"
        brew install --cask "$app"
        echo -e "${GREEN}✓ $app instalado${NC}"
    fi
done

# =============================================================================
# NERD FONTS
# =============================================================================

echo -e "\n${BLUE}=== Nerd Fonts ===${NC}"

# Tap de fuentes si no está agregado
if ! brew tap | grep -q "homebrew/cask-fonts"; then
    echo -e "${BLUE}Agregando tap de fuentes...${NC}"
    brew tap homebrew/cask-fonts
fi

# Array de fuentes Nerd Fonts populares
FONTS=(
    "font-fira-code-nerd-font"      # FiraCode con iconos
    "font-hack-nerd-font"           # Hack con iconos
    "font-meslo-lg-nerd-font"       # Meslo (recomendada para Powerlevel10k)
    "font-jetbrains-mono-nerd-font" # JetBrains Mono con iconos
)

for font in "${FONTS[@]}"; do
    if brew list --cask "$font" &>/dev/null; then
        echo -e "${GREEN}✓ $font ya está instalado${NC}"
    else
        echo -e "${BLUE}Instalando $font...${NC}"
        brew install --cask "$font"
        echo -e "${GREEN}✓ $font instalado${NC}"
    fi
done

# =============================================================================
# HERRAMIENTAS CLI ADICIONALES
# =============================================================================

echo -e "\n${BLUE}=== Herramientas CLI Adicionales ===${NC}"

CLI_EXTRAS=(
    "gh"        # GitHub CLI
    "fzf"       # Fuzzy finder
    "bat"       # Cat con syntax highlighting
    "eza"       # ls moderno (reemplazo de exa)
    "ripgrep"   # Búsqueda rápida (rg)
    "fd"        # Find moderno
    "tldr"      # Documentación simplificada
    "htop"      # Monitor de sistema
    "zoxide"    # cd inteligente (aprende tus directorios)
    "atuin"     # Historial de shell mejorado
    "lazygit"   # Git UI en terminal
    "gping"     # Ping con gráfico bonito
)

for tool in "${CLI_EXTRAS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo -e "${GREEN}✓ $tool ya está instalado${NC}"
    else
        echo -e "${BLUE}Instalando $tool...${NC}"
        brew install "$tool"
        echo -e "${GREEN}✓ $tool instalado${NC}"
    fi
done

# Configurar fzf
if command -v fzf &> /dev/null; then
    echo -e "${BLUE}Configurando fzf...${NC}"
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    echo -e "${GREEN}✓ fzf configurado${NC}"
fi

# Configurar zoxide
if command -v zoxide &> /dev/null; then
    echo -e "${BLUE}zoxide instalado (se configurará en .zshrc)${NC}"
fi

# Configurar atuin
if command -v atuin &> /dev/null; then
    echo -e "${BLUE}atuin instalado (se configurará en .zshrc)${NC}"
fi

echo -e "\n${GREEN}✓ Todas las aplicaciones instaladas${NC}"

# Mostrar resumen
echo -e "\n${BLUE}=== Aplicaciones Instaladas ===${NC}"
echo -e "Editores:"
echo -e "  • Visual Studio Code"
echo -e "  • Cursor"
echo -e ""
echo -e "Contenedores:"
echo -e "  • OrbStack"
echo -e ""
echo -e "Fuentes:"
echo -e "  • FiraCode Nerd Font"
echo -e "  • Hack Nerd Font"
echo -e "  • Meslo LG Nerd Font"
echo -e "  • JetBrains Mono Nerd Font"
echo -e ""
echo -e "Herramientas CLI Modernas:"
echo -e "  • gh (GitHub CLI)"
echo -e "  • fzf (Fuzzy finder)"
echo -e "  • bat (cat mejorado)"
echo -e "  • eza (ls moderno)"
echo -e "  • ripgrep (búsqueda rápida)"
echo -e "  • fd (find moderno)"
echo -e "  • zoxide (cd inteligente)"
echo -e "  • atuin (historial mejorado)"
echo -e "  • lazygit (Git UI)"
echo -e "  • gping (ping visual)"
echo -e ""
echo -e "${YELLOW}Notas:${NC}"
echo -e "  • Cambia la fuente de tu terminal a una Nerd Font para ver iconos"
echo -e "  • Usa 'z <dir>' en lugar de 'cd' para navegar con zoxide"
echo -e "  • Usa 'lg' para abrir lazygit en un repositorio"
