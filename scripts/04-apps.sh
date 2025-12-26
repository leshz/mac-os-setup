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
    "appcleaner"            # AppCleaner
    "bruno"                 # Bruno API Client
    "claude-code"           # Claude Code CLI
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

# Las fuentes ahora se instalan directamente sin necesidad de tap
# homebrew/cask-fonts fue deprecado y las fuentes se migraron al repositorio principal

# Array de fuentes Nerd Fonts populares
FONTS=(
    "font-fira-code-nerd-font"      # FiraCode con iconos
    "font-hack-nerd-font"           # Hack con iconos
    "font-meslo-lg-nerd-font"       # Meslo (recomendada para Powerlevel10k)
    "font-jetbrains-mono-nerd-font" # JetBrains Mono con iconos
    "font-maple-mono-nf"            # Maple Mono Nerd Font
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

echo -e "\n${GREEN}✓ Todas las aplicaciones instaladas${NC}"

# Mostrar resumen
echo -e "\n${BLUE}=== Aplicaciones Instaladas ===${NC}"
echo -e "Editores:"
echo -e "  • Visual Studio Code"
echo -e "  • Cursor"
echo -e "  • Claude Code CLI"
echo -e ""
echo -e "Contenedores:"
echo -e "  • OrbStack"
echo -e ""
echo -e "Utilidades:"
echo -e "  • AppCleaner"
echo -e "  • Bruno (API Client)"
echo -e ""
echo -e "Fuentes:"
echo -e "  • FiraCode Nerd Font"
echo -e "  • Hack Nerd Font"
echo -e "  • Meslo LG Nerd Font"
echo -e "  • JetBrains Mono Nerd Font"
echo -e "  • Maple Mono"
echo -e ""
echo -e "${YELLOW}Notas:${NC}"
echo -e "  • Cambia la fuente de tu terminal a una Nerd Font para ver iconos"
echo -e "  • Las herramientas CLI modernas se instalan en 01-homebrew.sh"
echo -e ""
echo -e "${YELLOW}Instalación manual requerida:${NC}"
echo -e "  • Boring Notch (Dynamic Island) - No disponible via Homebrew"
echo -e "    Descarga desde: https://www.boringnotch.com/"
