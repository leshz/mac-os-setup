#!/bin/bash

# =============================================================================
# MACOS CONFIGURATION
# Configura preferencias del sistema macOS
# Enfoque en: Organización de screenshots
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Configurando macOS...${NC}"

# =============================================================================
# SCREENSHOTS
# =============================================================================

echo -e "\n${BLUE}=== Configuración de Screenshots ===${NC}"

# Crear carpeta de Screenshots si no existe
mkdir -p "${HOME}/Desktop/Screenshots"

# Cambiar ubicación default de screenshots
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"
echo -e "${GREEN}✓ Ubicación de screenshots: ~/Desktop/Screenshots${NC}"

# Formato de screenshots (png, jpg, pdf, tiff)
defaults write com.apple.screencapture type -string "png"
echo -e "${GREEN}✓ Formato de screenshots: PNG${NC}"

# Deshabilitar sombra en screenshots
defaults write com.apple.screencapture disable-shadow -bool false
echo -e "${GREEN}✓ Sombra en screenshots deshabilitada${NC}"

# Aplicar cambios de screencapture
killall SystemUIServer 2>/dev/null || true

echo -e "\n${GREEN}✓ Configuración de macOS completada${NC}"
