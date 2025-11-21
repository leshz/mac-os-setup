#!/bin/bash

# =============================================================================
# MACOS CONFIGURATION
# Configura preferencias del sistema macOS
# Enfoque en: Input (teclado y trackpad)
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Configurando macOS...${NC}"

# Cerrar System Preferences para prevenir conflictos
osascript -e 'tell application "System Preferences" to quit'

echo -e "${YELLOW}Nota: Algunos cambios requieren reiniciar el sistema o cerrar sesión${NC}\n"

# =============================================================================
# TECLADO
# =============================================================================

echo -e "${BLUE}=== Configuración de Teclado ===${NC}"

# Velocidad de repetición de teclas (1 = más rápido, 120 = más lento)
# Valores: 15 = muy rápido, 2 = super rápido (requiere reinicio)
defaults write NSGlobalDomain KeyRepeat -int 2
echo -e "${GREEN}✓ Velocidad de repetición de teclas configurada al máximo${NC}"

# Delay hasta que las teclas empiezan a repetirse (15 = 225ms, más bajo = más rápido)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo -e "${GREEN}✓ Delay de repetición inicial reducido${NC}"

# Usar teclas de función F1, F2, etc. como teclas estándar
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
echo -e "${GREEN}✓ Teclas de función configuradas como estándar${NC}"

# Deshabilitar corrección automática
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
echo -e "${GREEN}✓ Corrección automática deshabilitada${NC}"

# Deshabilitar capitalización automática
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
echo -e "${GREEN}✓ Capitalización automática deshabilitada${NC}"

# Deshabilitar punto automático con doble espacio
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
echo -e "${GREEN}✓ Punto automático deshabilitado${NC}"

# Deshabilitar comillas inteligentes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
echo -e "${GREEN}✓ Comillas inteligentes deshabilitadas${NC}"

# Deshabilitar guiones inteligentes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
echo -e "${GREEN}✓ Guiones inteligentes deshabilitados${NC}"

# =============================================================================
# TRACKPAD
# =============================================================================

echo -e "\n${BLUE}=== Configuración de Trackpad ===${NC}"

# Habilitar tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
echo -e "${GREEN}✓ Tap to click habilitado${NC}"

# Velocidad del trackpad (1-3, donde 3 es más rápido)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3
echo -e "${GREEN}✓ Velocidad del trackpad al máximo${NC}"

# Scroll natural (descomenta la siguiente línea si prefieres deshabilitarlo)
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# =============================================================================
# DOCK
# =============================================================================

echo -e "\n${BLUE}=== Configuración de Dock ===${NC}"

# Auto-hide el Dock
defaults write com.apple.dock autohide -bool true
echo -e "${GREEN}✓ Auto-hide del Dock habilitado${NC}"

# Reducir delay de aparición del Dock
defaults write com.apple.dock autohide-delay -float 0
echo -e "${GREEN}✓ Delay del Dock reducido a 0${NC}"

# Velocidad de animación del Dock
defaults write com.apple.dock autohide-time-modifier -float 0.5
echo -e "${GREEN}✓ Animación del Dock acelerada${NC}"

# Tamaño de iconos del Dock
defaults write com.apple.dock tilesize -int 48
echo -e "${GREEN}✓ Tamaño de iconos del Dock configurado${NC}"

# Mostrar indicadores de aplicaciones abiertas
defaults write com.apple.dock show-process-indicators -bool true
echo -e "${GREEN}✓ Indicadores de apps abiertas habilitados${NC}"

# =============================================================================
# FINDER
# =============================================================================

echo -e "\n${BLUE}=== Configuración de Finder ===${NC}"

# Mostrar todas las extensiones de archivos
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo -e "${GREEN}✓ Extensiones de archivos visibles${NC}"

# Mostrar archivos ocultos
defaults write com.apple.finder AppleShowAllFiles -bool true
echo -e "${GREEN}✓ Archivos ocultos visibles${NC}"

# Mostrar path bar en Finder
defaults write com.apple.finder ShowPathbar -bool true
echo -e "${GREEN}✓ Path bar habilitada${NC}"

# Mostrar status bar en Finder
defaults write com.apple.finder ShowStatusBar -bool true
echo -e "${GREEN}✓ Status bar habilitada${NC}"

# Búsqueda en carpeta actual por defecto
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
echo -e "${GREEN}✓ Búsqueda en carpeta actual configurada${NC}"

# Deshabilitar advertencia al cambiar extensiones
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
echo -e "${GREEN}✓ Advertencia de cambio de extensión deshabilitada${NC}"

# Vista en lista como default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
echo -e "${GREEN}✓ Vista en lista configurada como default${NC}"

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
defaults write com.apple.screencapture disable-shadow -bool true
echo -e "${GREEN}✓ Sombra en screenshots deshabilitada${NC}"

# =============================================================================
# OTROS
# =============================================================================

echo -e "\n${BLUE}=== Otras Configuraciones ===${NC}"

# Expandir diálogos de guardar por defecto
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
echo -e "${GREEN}✓ Diálogos de guardar expandidos por defecto${NC}"

# Expandir diálogos de impresión por defecto
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
echo -e "${GREEN}✓ Diálogos de impresión expandidos por defecto${NC}"

# Deshabilitar "Are you sure you want to open this application?"
defaults write com.apple.LaunchServices LSQuarantine -bool false
echo -e "${GREEN}✓ Advertencia de apertura de apps deshabilitada${NC}"

# =============================================================================
# APLICAR CAMBIOS
# =============================================================================

echo -e "\n${BLUE}Aplicando cambios...${NC}"

# Reiniciar servicios afectados
killall Dock
killall Finder
killall SystemUIServer

echo -e "${GREEN}✓ Cambios aplicados${NC}"

echo -e "\n${YELLOW}================================${NC}"
echo -e "${YELLOW}IMPORTANTE:${NC}"
echo -e "Algunos cambios requieren:"
echo -e "  1. Cerrar sesión y volver a entrar"
echo -e "  2. O reiniciar el sistema"
echo -e "${YELLOW}================================${NC}"

echo -e "\n${GREEN}✓ Configuración de macOS completada${NC}"
