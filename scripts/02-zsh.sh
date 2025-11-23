#!/bin/bash

# =============================================================================
# ZSH + OH MY ZSH SETUP
# Instala y configura Zsh con Oh My Zsh
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Configurando Zsh...${NC}"

# Verificar si Zsh está instalado
if ! command -v zsh &> /dev/null; then
    echo -e "${YELLOW}Instalando Zsh...${NC}"
    brew install zsh
fi

echo -e "${GREEN}✓ Zsh instalado${NC}"

# Cambiar shell por defecto a Zsh si no lo es
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${BLUE}Cambiando shell por defecto a Zsh...${NC}"
    chsh -s $(which zsh)
    echo -e "${GREEN}✓ Shell cambiado a Zsh${NC}"
else
    echo -e "${GREEN}✓ Zsh ya es el shell por defecto${NC}"
fi

# Instalar Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "${BLUE}Instalando Oh My Zsh...${NC}"

    # Instalar Oh My Zsh sin iniciar zsh automáticamente
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo -e "${GREEN}✓ Oh My Zsh instalado${NC}"
else
    echo -e "${GREEN}✓ Oh My Zsh ya está instalado${NC}"

    # Actualizar Oh My Zsh
    echo -e "${BLUE}Actualizando Oh My Zsh...${NC}"
    cd ~/.oh-my-zsh && git pull
    cd - > /dev/null
fi

# Instalar plugins populares
echo -e "\n${BLUE}Instalando plugins de Zsh...${NC}"

# zsh-autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    echo -e "${BLUE}Instalando zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo -e "${GREEN}✓ zsh-autosuggestions instalado${NC}"
else
    echo -e "${GREEN}✓ zsh-autosuggestions ya está instalado${NC}"
fi

# zsh-syntax-highlighting
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
    echo -e "${BLUE}Instalando zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo -e "${GREEN}✓ zsh-syntax-highlighting instalado${NC}"
else
    echo -e "${GREEN}✓ zsh-syntax-highlighting ya está instalado${NC}"
fi

# zsh-completions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
    echo -e "${BLUE}Instalando zsh-completions...${NC}"
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
    echo -e "${GREEN}✓ zsh-completions instalado${NC}"
else
    echo -e "${GREEN}✓ zsh-completions ya está instalado${NC}"
fi

echo -e "\n${BLUE}Nota: Usaremos Starship como prompt (instalado con brew)${NC}"
echo -e "${YELLOW}Starship es más rápido y personalizable que Powerlevel10k${NC}"

echo -e "\n${GREEN}✓ Configuración de Zsh completada${NC}"
