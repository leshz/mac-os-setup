#!/bin/bash

# =============================================================================
# LANGUAGES SETUP
# Instala Node.js (nvm) y Python (pyenv)
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Configurando lenguajes de programación...${NC}"

# =============================================================================
# NODE.JS (NVM)
# =============================================================================

echo -e "\n${BLUE}=== Node.js con NVM ===${NC}"

if [[ -d "$HOME/.nvm" ]]; then
    echo -e "${GREEN}✓ NVM ya está instalado${NC}"
else
    echo -e "${BLUE}Instalando NVM...${NC}"

    # Instalar NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Cargar NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo -e "${GREEN}✓ NVM instalado${NC}"
fi

# Cargar NVM si no está cargado
if ! command -v nvm &> /dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Instalar Node.js LTS
if command -v nvm &> /dev/null; then
    echo -e "${BLUE}Instalando Node.js LTS...${NC}"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'

    echo -e "${GREEN}✓ Node.js instalado: $(node --version)${NC}"
    echo -e "${GREEN}✓ npm instalado: $(npm --version)${NC}"

    # Instalar pnpm y yarn globalmente
    echo -e "${BLUE}Instalando gestores de paquetes adicionales...${NC}"
    npm install -g pnpm yarn

    echo -e "${GREEN}✓ pnpm instalado: $(pnpm --version)${NC}"
    echo -e "${GREEN}✓ yarn instalado: $(yarn --version)${NC}"
else
    echo -e "${RED}✗ Error: NVM no se pudo cargar correctamente${NC}"
fi

# =============================================================================
# PYTHON (PYENV)
# =============================================================================

echo -e "\n${BLUE}=== Python con Pyenv ===${NC}"

if command -v pyenv &> /dev/null; then
    echo -e "${GREEN}✓ Pyenv ya está instalado${NC}"
else
    echo -e "${BLUE}Instalando Pyenv...${NC}"
    brew install pyenv pyenv-virtualenv

    echo -e "${GREEN}✓ Pyenv instalado${NC}"
fi

# Configurar pyenv en el shell actual
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Instalar Python (última versión estable)
echo -e "${BLUE}Instalando Python...${NC}"

# Obtener la última versión de Python 3.12.x
PYTHON_VERSION=$(pyenv install --list | grep -E '^\s*3\.12\.[0-9]+$' | tail -1 | xargs)

if [[ -z "$PYTHON_VERSION" ]]; then
    # Fallback a 3.11 si 3.12 no está disponible
    PYTHON_VERSION=$(pyenv install --list | grep -E '^\s*3\.11\.[0-9]+$' | tail -1 | xargs)
fi

# Verificar si ya está instalado
if pyenv versions | grep -q "$PYTHON_VERSION"; then
    echo -e "${GREEN}✓ Python $PYTHON_VERSION ya está instalado${NC}"
else
    echo -e "${BLUE}Instalando Python $PYTHON_VERSION...${NC}"
    pyenv install "$PYTHON_VERSION"
fi

# Configurar como versión global
pyenv global "$PYTHON_VERSION"

echo -e "${GREEN}✓ Python instalado: $(python --version)${NC}"
echo -e "${GREEN}✓ pip instalado: $(pip --version)${NC}"

# Actualizar pip
echo -e "${BLUE}Actualizando pip...${NC}"
pip install --upgrade pip

# Instalar herramientas comunes de Python
echo -e "${BLUE}Instalando herramientas de Python...${NC}"
pip install pipenv poetry virtualenv

echo -e "${GREEN}✓ pipenv instalado${NC}"
echo -e "${GREEN}✓ poetry instalado${NC}"
echo -e "${GREEN}✓ virtualenv instalado${NC}"

echo -e "\n${GREEN}✓ Configuración de lenguajes completada${NC}"
