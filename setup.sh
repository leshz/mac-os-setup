#!/bin/bash

# =============================================================================
# MAC SETUP SCRIPT
# Script de configuración automatizada para macOS
# Modo: Semi-automático (confirmación antes de cambios importantes)
# =============================================================================

set -e  # Salir si algún comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
LOG_FILE="${SCRIPT_DIR}/setup.log"

# =============================================================================
# FUNCIONES AUXILIARES
# =============================================================================

print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Función para pedir confirmación
confirm() {
    local message="$1"
    local response

    echo -e "\n${YELLOW}$message (s/n): ${NC}"
    read -r response

    if [[ "$response" =~ ^[Ss]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Función para ejecutar un script con confirmación
run_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local description="$2"

    print_header "$description"

    if confirm "¿Ejecutar $script_name?"; then
        print_info "Ejecutando $script_name..."

        if bash "$script_path" 2>&1 | tee -a "$LOG_FILE"; then
            print_success "$description completado"
            return 0
        else
            print_error "$description falló"
            if confirm "¿Continuar con el siguiente paso?"; then
                return 1
            else
                exit 1
            fi
        fi
    else
        print_warning "$description omitido"
        return 2
    fi
}

# =============================================================================
# VERIFICACIONES INICIALES
# =============================================================================

print_header "MAC SETUP - Configuración Automatizada"

# Verificar que estamos en macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "Este script solo funciona en macOS"
    exit 1
fi

# Detectar arquitectura
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    print_info "Detectado: Apple Silicon (M1/M2/M3)"
    BREW_PREFIX="/opt/homebrew"
else
    print_info "Detectado: Intel Mac"
    BREW_PREFIX="/usr/local"
fi

# Inicializar log
echo "=== Setup iniciado: $(date) ===" > "$LOG_FILE"
echo "Arquitectura: $ARCH" >> "$LOG_FILE"

# =============================================================================
# EJECUCIÓN DE SCRIPTS
# =============================================================================

print_info "Este proceso instalará y configurará:"
echo "  1. Homebrew"
echo "  2. Zsh + Oh My Zsh"
echo "  3. Node.js (nvm) y Python (pyenv)"
echo "  4. Aplicaciones (VSCode, Cursor, OrbStack)"
echo "  5. Configuraciones de macOS"
echo "  6. Dotfiles"

if ! confirm "¿Deseas continuar con la instalación completa?"; then
    print_warning "Instalación cancelada"
    exit 0
fi

# 1. Homebrew
run_script "${SCRIPTS_DIR}/01-homebrew.sh" "Instalación de Homebrew"

# 2. Zsh y Oh My Zsh
run_script "${SCRIPTS_DIR}/02-zsh.sh" "Configuración de Zsh"

# 3. Lenguajes (Node.js y Python)
run_script "${SCRIPTS_DIR}/03-languages.sh" "Instalación de lenguajes (Node.js, Python)"

# 4. Aplicaciones
run_script "${SCRIPTS_DIR}/04-apps.sh" "Instalación de aplicaciones"

# 5. Configuraciones macOS
run_script "${SCRIPTS_DIR}/05-macos.sh" "Configuraciones de macOS"

# 6. Dotfiles
run_script "${SCRIPTS_DIR}/06-dotfiles.sh" "Configuración de dotfiles"

# =============================================================================
# FINALIZACIÓN
# =============================================================================

print_header "INSTALACIÓN COMPLETADA"

print_success "Tu Mac ha sido configurado exitosamente!"
print_info "Log guardado en: $LOG_FILE"

echo -e "\n${YELLOW}PRÓXIMOS PASOS:${NC}"
echo "  1. Reinicia tu terminal para aplicar todos los cambios"
echo "  2. Configura Git con tus credenciales:"
echo "     git config --global user.name \"Tu Nombre\""
echo "     git config --global user.email \"tu@email.com\""
echo "  3. Considera crear un repositorio de dotfiles para respaldar tu configuración"
echo ""

if confirm "¿Deseas reiniciar la terminal ahora?"; then
    print_info "Reiniciando terminal..."
    exec $SHELL -l
fi

print_success "¡Todo listo! Disfruta tu Mac configurado."
