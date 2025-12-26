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

# =============================================================================
# HERRAMIENTAS CLI BÁSICAS
# =============================================================================

echo -e "\n${BLUE}=== Herramientas CLI Básicas ===${NC}"

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

# =============================================================================
# HERRAMIENTAS CLI MODERNAS
# =============================================================================

echo -e "\n${BLUE}=== Herramientas CLI Modernas ===${NC}"

CLI_MODERN=(
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
    "starship"
    "lsd"  # Prompt moderno y rápido
    "neovim"    # Editor de texto moderno (vim mejorado)
)

for tool in "${CLI_MODERN[@]}"; do
    if brew list "$tool" &>/dev/null; then
        echo -e "${GREEN}✓ $tool ya está instalado${NC}"
    else
        echo -e "${BLUE}Instalando $tool...${NC}"
        brew install "$tool"
        echo -e "${GREEN}✓ $tool instalado${NC}"
    fi
done

# =============================================================================
# CONFIGURACIONES POST-INSTALACIÓN
# =============================================================================

# Configurar fzf
if command -v fzf &> /dev/null; then
    echo -e "\n${BLUE}Configurando fzf...${NC}"
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    echo -e "${GREEN}✓ fzf configurado${NC}"
fi

# Configurar zoxide
if command -v zoxide &> /dev/null; then
    echo -e "${BLUE}✓ zoxide instalado (se configurará en .zshrc)${NC}"
fi

# Configurar atuin
if command -v atuin &> /dev/null; then
    echo -e "${BLUE}✓ atuin instalado (se configurará en .zshrc)${NC}"
fi

# Configurar starship
if command -v starship &> /dev/null; then
    echo -e "${BLUE}✓ starship instalado (se configurará en .zshrc)${NC}"
fi

echo -e "\n${GREEN}✓ Todas las herramientas CLI instaladas${NC}"
