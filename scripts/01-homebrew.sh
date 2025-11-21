#!/bin/bash

# =============================================================================
# HOMEBREW INSTALLATION
# Instala Homebrew si no está instalado
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Verificando Homebrew...${NC}"

# Verificar si Homebrew ya está instalado
if command -v brew &> /dev/null; then
    echo -e "${GREEN}✓ Homebrew ya está instalado${NC}"

    # Actualizar Homebrew
    echo -e "${BLUE}Actualizando Homebrew...${NC}"
    brew update
    brew upgrade

    echo -e "${GREEN}✓ Homebrew actualizado${NC}"
else
    echo -e "${YELLOW}Homebrew no está instalado. Instalando...${NC}"

    # Instalar Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Detectar arquitectura y configurar PATH
    ARCH=$(uname -m)

    if [[ "$ARCH" == "arm64" ]]; then
        # Apple Silicon
        BREW_PREFIX="/opt/homebrew"
        echo -e "${BLUE}Configurando Homebrew para Apple Silicon...${NC}"

        # Agregar a PATH temporalmente
        eval "$($BREW_PREFIX/bin/brew shellenv)"

        # Agregar a shell profile si no existe
        if ! grep -q "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" ~/.zprofile 2>/dev/null; then
            echo "eval \"\$($BREW_PREFIX/bin/brew shellenv)\"" >> ~/.zprofile
        fi

    else
        # Intel
        BREW_PREFIX="/usr/local"
        echo -e "${BLUE}Configurando Homebrew para Intel Mac...${NC}"
        eval "$($BREW_PREFIX/bin/brew shellenv)"
    fi

    echo -e "${GREEN}✓ Homebrew instalado exitosamente${NC}"
fi

# Verificar instalación
brew --version

# Instalar herramientas CLI básicas
echo -e "\n${BLUE}Instalando herramientas CLI básicas...${NC}"

# Array de herramientas esenciales
CLI_TOOLS=(
    "git"           # Control de versiones
    "wget"          # Descarga de archivos
    "curl"          # Transferencia de datos
    "tree"          # Visualización de directorios
    "jq"            # Procesador JSON
)

for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo -e "${GREEN}✓ $tool ya está instalado${NC}"
    else
        echo -e "${BLUE}Instalando $tool...${NC}"
        brew install "$tool"
        echo -e "${GREEN}✓ $tool instalado${NC}"
    fi
done

echo -e "\n${GREEN}✓ Homebrew configurado completamente${NC}"
