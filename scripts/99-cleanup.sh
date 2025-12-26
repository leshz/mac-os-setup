#!/bin/bash

# =============================================================================
# CLEANUP SCRIPT
# Desinstala aplicaciones y remueve configuraciones realizadas por los scripts
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# =============================================================================
# FUNCIONES DE UTILIDAD
# =============================================================================

ask_confirmation() {
    local prompt="$1"
    local response

    echo -e "${YELLOW}${prompt} (y/N)${NC}"
    read -r response

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# =============================================================================
# BANNER
# =============================================================================

echo -e "${RED}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║                    CLEANUP SCRIPT                             ║
║                                                               ║
║   Este script desinstalará aplicaciones y configuraciones    ║
║   instaladas por los scripts de setup                        ║
║                                                               ║
║   ⚠️  ADVERTENCIA: Esta acción no se puede deshacer          ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

if ! ask_confirmation "¿Estás seguro de que quieres continuar?"; then
    echo -e "${YELLOW}Operación cancelada${NC}"
    exit 0
fi

# =============================================================================
# MENU DE OPCIONES
# =============================================================================

echo -e "\n${BLUE}Selecciona qué deseas desinstalar:${NC}\n"

echo "1. Aplicaciones GUI (VSCode, Cursor, OrbStack, etc.)"
echo "2. Herramientas CLI (gh, fzf, bat, eza, ripgrep, etc.)"
echo "3. Nerd Fonts"
echo "4. Lenguajes (Node.js/NVM, Python/Pyenv)"
echo "5. Oh My Zsh y plugins"
echo "6. Dotfiles y configuraciones"
echo "7. Restaurar configuraciones de macOS"
echo "8. Desinstalar Homebrew"
echo "9. TODO LO ANTERIOR (limpieza completa)"
echo "0. Salir"
echo ""

read -p "Ingresa tu opción (0-9): " option

case $option in
    0)
        echo -e "${YELLOW}Operación cancelada${NC}"
        exit 0
        ;;
    9)
        CLEAN_ALL=true
        ;;
    *)
        CLEAN_ALL=false
        ;;
esac

# =============================================================================
# 1. DESINSTALAR APLICACIONES GUI
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "1" ]]; then
    echo -e "\n${BLUE}=== Desinstalando Aplicaciones GUI ===${NC}"

    APPS=(
        "visual-studio-code"
        "cursor"
        "orbstack"
        "appcleaner"
        "boring-notch"
        "bruno"
        "claude-code"
    )

    for app in "${APPS[@]}"; do
        if brew list --cask "$app" &>/dev/null; then
            echo -e "${BLUE}Desinstalando $app...${NC}"
            brew uninstall --cask "$app" --force
            echo -e "${GREEN}✓ $app desinstalado${NC}"
        else
            echo -e "${YELLOW}⚠ $app no está instalado${NC}"
        fi
    done
fi

# =============================================================================
# 2. DESINSTALAR HERRAMIENTAS CLI
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "2" ]]; then
    echo -e "\n${BLUE}=== Desinstalando Herramientas CLI ===${NC}"

    CLI_TOOLS=(
        # De 01-homebrew.sh
        "git"
        "wget"
        "curl"
        "tree"
        "jq"
        # De 04-apps.sh
        "gh"
        "fzf"
        "bat"
        "eza"
        "ripgrep"
        "fd"
        "tldr"
        "htop"
        "zoxide"
        "atuin"
        "lazygit"
        "gping"
        "starship"
        "neovim"
    )

    for tool in "${CLI_TOOLS[@]}"; do
        if brew list "$tool" &>/dev/null; then
            echo -e "${BLUE}Desinstalando $tool...${NC}"
            brew uninstall "$tool" --force
            echo -e "${GREEN}✓ $tool desinstalado${NC}"
        else
            echo -e "${YELLOW}⚠ $tool no está instalado${NC}"
        fi
    done

    # Limpiar configuraciones específicas
    if [[ -f "$HOME/.zoxide" ]]; then
        rm -f "$HOME/.zoxide"
        echo -e "${GREEN}✓ Configuración de zoxide eliminada${NC}"
    fi

    if [[ -d "$HOME/.local/share/atuin" ]]; then
        rm -rf "$HOME/.local/share/atuin"
        echo -e "${GREEN}✓ Datos de atuin eliminados${NC}"
    fi
fi

# =============================================================================
# 3. DESINSTALAR NERD FONTS
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "3" ]]; then
    echo -e "\n${BLUE}=== Desinstalando Nerd Fonts ===${NC}"

    FONTS=(
        "font-fira-code-nerd-font"
        "font-hack-nerd-font"
        "font-meslo-lg-nerd-font"
        "font-jetbrains-mono-nerd-font"
        "font-maple-mono"
    )

    for font in "${FONTS[@]}"; do
        if brew list --cask "$font" &>/dev/null; then
            echo -e "${BLUE}Desinstalando $font...${NC}"
            brew uninstall --cask "$font" --force
            echo -e "${GREEN}✓ $font desinstalado${NC}"
        else
            echo -e "${YELLOW}⚠ $font no está instalado${NC}"
        fi
    done
fi

# =============================================================================
# 4. DESINSTALAR LENGUAJES
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "4" ]]; then
    echo -e "\n${BLUE}=== Desinstalando Lenguajes ===${NC}"

    # Node.js / NVM
    if [[ -d "$HOME/.nvm" ]]; then
        if ask_confirmation "¿Desinstalar NVM y todas las versiones de Node.js?"; then
            echo -e "${BLUE}Desinstalando NVM...${NC}"
            rm -rf "$HOME/.nvm"
            echo -e "${GREEN}✓ NVM desinstalado${NC}"

            # Limpiar del .zshrc
            if [[ -f "$HOME/.zshrc" ]]; then
                sed -i.backup '/NVM_DIR/d' "$HOME/.zshrc"
                sed -i.backup '/nvm\.sh/d' "$HOME/.zshrc"
            fi
        fi
    else
        echo -e "${YELLOW}⚠ NVM no está instalado${NC}"
    fi

    # Python / Pyenv
    if command -v pyenv &> /dev/null; then
        if ask_confirmation "¿Desinstalar Pyenv y todas las versiones de Python?"; then
            echo -e "${BLUE}Desinstalando Pyenv...${NC}"

            # Desinstalar pyenv con brew
            brew uninstall pyenv pyenv-virtualenv --force

            # Eliminar directorio de pyenv
            if [[ -d "$HOME/.pyenv" ]]; then
                rm -rf "$HOME/.pyenv"
            fi

            echo -e "${GREEN}✓ Pyenv desinstalado${NC}"

            # Limpiar del .zshrc
            if [[ -f "$HOME/.zshrc" ]]; then
                sed -i.backup '/PYENV_ROOT/d' "$HOME/.zshrc"
                sed -i.backup '/pyenv init/d' "$HOME/.zshrc"
                sed -i.backup '/pyenv virtualenv-init/d' "$HOME/.zshrc"
            fi
        fi
    else
        echo -e "${YELLOW}⚠ Pyenv no está instalado${NC}"
    fi
fi

# =============================================================================
# 5. DESINSTALAR OH MY ZSH
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "5" ]]; then
    echo -e "\n${BLUE}=== Desinstalando Oh My Zsh ===${NC}"

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        if ask_confirmation "¿Desinstalar Oh My Zsh y todos sus plugins?"; then
            echo -e "${BLUE}Desinstalando Oh My Zsh...${NC}"

            # Desinstalar usando el script oficial
            if [[ -f "$HOME/.oh-my-zsh/tools/uninstall.sh" ]]; then
                ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/uninstall.sh" || true
            else
                # Desinstalación manual
                rm -rf "$HOME/.oh-my-zsh"
            fi

            echo -e "${GREEN}✓ Oh My Zsh desinstalado${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Oh My Zsh no está instalado${NC}"
    fi

    # Cambiar shell de vuelta a bash si es necesario
    if [[ "$SHELL" == *"zsh"* ]]; then
        if ask_confirmation "¿Cambiar el shell por defecto de vuelta a bash?"; then
            chsh -s /bin/bash
            echo -e "${GREEN}✓ Shell cambiado a bash${NC}"
        fi
    fi
fi

# =============================================================================
# 6. ELIMINAR DOTFILES Y CONFIGURACIONES
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "6" ]]; then
    echo -e "\n${BLUE}=== Eliminando Dotfiles y Configuraciones ===${NC}"

    if ask_confirmation "¿Eliminar dotfiles (.zshrc, .gitconfig, etc.)?"; then

        # Eliminar dotfiles
        DOTFILES=(
            "$HOME/.zshrc"
            "$HOME/.gitconfig"
            "$HOME/.gitignore_global"
            "$HOME/.config/starship.toml"
        )

        for file in "${DOTFILES[@]}"; do
            if [[ -f "$file" ]]; then
                echo -e "${BLUE}Eliminando $file...${NC}"
                rm -f "$file"
                echo -e "${GREEN}✓ $file eliminado${NC}"
            fi
        done

        # Eliminar LazyVim
        if [[ -d "$HOME/.config/nvim" ]]; then
            if ask_confirmation "¿Eliminar configuración de LazyVim (~/.config/nvim)?"; then
                echo -e "${BLUE}Eliminando LazyVim...${NC}"
                rm -rf "$HOME/.config/nvim"

                # Eliminar también cache de Neovim
                rm -rf "$HOME/.local/share/nvim"
                rm -rf "$HOME/.local/state/nvim"
                rm -rf "$HOME/.cache/nvim"

                echo -e "${GREEN}✓ LazyVim eliminado${NC}"
            fi
        fi

        # Eliminar backups
        echo -e "${BLUE}Eliminando backups...${NC}"
        rm -f "$HOME/.zshrc.backup"*
        rm -f "$HOME/.gitconfig.backup"*
        rm -f "$HOME/.gitignore_global.backup"*
        rm -f "$HOME/.config/starship.toml.backup"*
        rm -rf "$HOME/.config/nvim.backup"*
        echo -e "${GREEN}✓ Backups eliminados${NC}"

        # Eliminar SSH config (opcional)
        if [[ -f "$HOME/.ssh/config" ]]; then
            if ask_confirmation "¿Eliminar configuración SSH (~/.ssh/config)?"; then
                rm -f "$HOME/.ssh/config"
                echo -e "${GREEN}✓ SSH config eliminado${NC}"
            fi
        fi
    fi
fi

# =============================================================================
# 7. RESTAURAR CONFIGURACIONES DE MACOS
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "7" ]]; then
    echo -e "\n${BLUE}=== Restaurando Configuraciones de macOS ===${NC}"

    if ask_confirmation "¿Restaurar configuraciones de macOS a los valores por defecto?"; then

        # Cerrar System Preferences
        osascript -e 'tell application "System Preferences" to quit'

        echo -e "${BLUE}Restaurando teclado...${NC}"
        defaults delete NSGlobalDomain KeyRepeat 2>/dev/null || true
        defaults delete NSGlobalDomain InitialKeyRepeat 2>/dev/null || true
        defaults delete NSGlobalDomain com.apple.keyboard.fnState 2>/dev/null || true
        defaults delete NSGlobalDomain NSAutomaticSpellingCorrectionEnabled 2>/dev/null || true
        defaults delete NSGlobalDomain NSAutomaticCapitalizationEnabled 2>/dev/null || true
        defaults delete NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled 2>/dev/null || true
        defaults delete NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled 2>/dev/null || true
        defaults delete NSGlobalDomain NSAutomaticDashSubstitutionEnabled 2>/dev/null || true

        echo -e "${BLUE}Restaurando trackpad...${NC}"
        defaults delete com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking 2>/dev/null || true
        defaults delete NSGlobalDomain com.apple.mouse.tapBehavior 2>/dev/null || true
        defaults delete NSGlobalDomain com.apple.trackpad.scaling 2>/dev/null || true

        echo -e "${BLUE}Restaurando Dock...${NC}"
        defaults delete com.apple.dock autohide 2>/dev/null || true
        defaults delete com.apple.dock autohide-delay 2>/dev/null || true
        defaults delete com.apple.dock autohide-time-modifier 2>/dev/null || true
        defaults delete com.apple.dock tilesize 2>/dev/null || true
        defaults delete com.apple.dock show-process-indicators 2>/dev/null || true

        echo -e "${BLUE}Restaurando Finder...${NC}"
        defaults delete NSGlobalDomain AppleShowAllExtensions 2>/dev/null || true
        defaults delete com.apple.finder AppleShowAllFiles 2>/dev/null || true
        defaults delete com.apple.finder ShowPathbar 2>/dev/null || true
        defaults delete com.apple.finder ShowStatusBar 2>/dev/null || true
        defaults delete com.apple.finder FXDefaultSearchScope 2>/dev/null || true
        defaults delete com.apple.finder FXEnableExtensionChangeWarning 2>/dev/null || true
        defaults delete com.apple.finder FXPreferredViewStyle 2>/dev/null || true

        echo -e "${BLUE}Restaurando screenshots...${NC}"
        defaults delete com.apple.screencapture location 2>/dev/null || true
        defaults delete com.apple.screencapture type 2>/dev/null || true
        defaults delete com.apple.screencapture disable-shadow 2>/dev/null || true

        echo -e "${BLUE}Restaurando otras configuraciones...${NC}"
        defaults delete NSGlobalDomain NSNavPanelExpandedStateForSaveMode 2>/dev/null || true
        defaults delete NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 2>/dev/null || true
        defaults delete NSGlobalDomain PMPrintingExpandedStateForPrint 2>/dev/null || true
        defaults delete NSGlobalDomain PMPrintingExpandedStateForPrint2 2>/dev/null || true
        defaults delete com.apple.LaunchServices LSQuarantine 2>/dev/null || true

        # Reiniciar servicios
        killall Dock
        killall Finder
        killall SystemUIServer

        echo -e "${GREEN}✓ Configuraciones de macOS restauradas${NC}"
        echo -e "${YELLOW}Puede ser necesario reiniciar para aplicar todos los cambios${NC}"
    fi
fi

# =============================================================================
# 8. DESINSTALAR HOMEBREW
# =============================================================================

if [[ "$CLEAN_ALL" == "true" ]] || [[ "$option" == "8" ]]; then
    echo -e "\n${BLUE}=== Desinstalar Homebrew ===${NC}"

    if command -v brew &> /dev/null; then
        echo -e "${RED}⚠️  ADVERTENCIA: Esto desinstalará Homebrew completamente${NC}"
        echo -e "${RED}    y TODAS las aplicaciones instaladas con brew${NC}"

        if ask_confirmation "¿Estás ABSOLUTAMENTE SEGURO?"; then
            echo -e "${BLUE}Desinstalando Homebrew...${NC}"

            # Usar el script oficial de desinstalación
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

            # Limpiar del .zprofile y .zshrc
            if [[ -f "$HOME/.zprofile" ]]; then
                sed -i.backup '/brew shellenv/d' "$HOME/.zprofile"
            fi

            if [[ -f "$HOME/.zshrc" ]]; then
                sed -i.backup '/brew shellenv/d' "$HOME/.zshrc"
            fi

            echo -e "${GREEN}✓ Homebrew desinstalado${NC}"
        fi
    else
        echo -e "${YELLOW}⚠ Homebrew no está instalado${NC}"
    fi
fi

# =============================================================================
# CLEANUP FINAL
# =============================================================================

echo -e "\n${BLUE}=== Limpieza Final ===${NC}"

# Limpiar cachés de Homebrew si todavía existe
if command -v brew &> /dev/null; then
    echo -e "${BLUE}Limpiando cachés de Homebrew...${NC}"
    brew cleanup -s
    rm -rf "$(brew --cache)"
    echo -e "${GREEN}✓ Cachés limpiados${NC}"
fi

# Limpiar archivos de backup de sed
echo -e "${BLUE}Limpiando archivos temporales...${NC}"
rm -f "$HOME/.zshrc.backup"
rm -f "$HOME/.zprofile.backup"
echo -e "${GREEN}✓ Archivos temporales eliminados${NC}"

# =============================================================================
# RESUMEN FINAL
# =============================================================================

echo -e "\n${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║                    LIMPIEZA COMPLETADA                        ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

echo -e "${YELLOW}Notas importantes:${NC}"
echo -e "  • Es recomendable reiniciar tu sistema para aplicar todos los cambios"
echo -e "  • Algunos directorios (~/Developer, ~/Projects) no fueron eliminados"
echo -e "  • Los backups de tus dotfiles están en ~/.<archivo>.backup.*"
echo -e ""
echo -e "${GREEN}✓ Limpieza completada exitosamente${NC}"
