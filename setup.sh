#!/bin/bash

# =============================================================================
# MAC SETUP SCRIPT
# Automated configuration script for macOS
# Supports both sequential and interactive menu modes
# =============================================================================

# Dry-run mode: only shows what would be done without executing
DRY_RUN=false
if [[ "$1" == "--dry-run" ]] || [[ "$1" == "-n" ]] || [[ "$1" == "--test" ]]; then
    DRY_RUN=true
    export DRY_RUN
fi

if [[ "$DRY_RUN" == false ]]; then
    set -e  # Exit if any command fails
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"
LOG_FILE="${SCRIPT_DIR}/setup.log"

# =============================================================================
# HELPER FUNCTIONS
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

# Function to ask for confirmation
confirm() {
    local message="$1"
    local response

    echo -e "\n${YELLOW}$message (y/n): ${NC}"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to execute a script with confirmation
run_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local description="$2"

    print_header "$description"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would execute: bash $script_path"
        case "$script_name" in
            "01-homebrew.sh")
                echo -e "${BLUE}  → Would install Homebrew and basic CLI tools${NC}"
                ;;
            "02-zsh.sh")
                echo -e "${BLUE}  → Would install Oh My Zsh, Powerlevel10k and plugins${NC}"
                ;;
            "03-languages.sh")
                echo -e "${BLUE}  → Would install Node.js (nvm), Python (pyenv), Go${NC}"
                ;;
            "04-apps.sh")
                echo -e "${BLUE}  → Would install GUI applications and CLI tools${NC}"
                ;;
            "05-macos.sh")
                echo -e "${BLUE}  → Would configure system preferences${NC}"
                ;;
            "06-dotfiles.sh")
                echo -e "${BLUE}  → Would copy configuration files${NC}"
                ;;
        esac
        return 0
    fi

    if confirm "Execute $script_name?"; then
        print_info "Executing $script_name..."

        if bash "$script_path" 2>&1 | tee -a "$LOG_FILE"; then
            print_success "$description completed"
            return 0
        else
            print_error "$description failed"
            if confirm "Continue with next step?"; then
                return 1
            else
                exit 1
            fi
        fi
    else
        print_warning "$description skipped"
        return 2
    fi
}

# =============================================================================
# ASCII ART
# =============================================================================

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ███████╗██╗  ██╗███████╗
    ██╔════╝██║  ██║╚══███╔╝
    ███████╗███████║  ███╔╝
    ╚════██║██╔══██║ ███╔╝
    ███████║██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚══════╝
EOF
    echo -e "${NC}"
    echo -e "${BOLD}${MAGENTA}macOS Development Environment Setup${NC}"
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}${BOLD}🧪 TEST MODE (DRY RUN)${NC}"
        echo -e "${YELLOW}No changes will be made to the system${NC}"
    fi
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# =============================================================================
# INDIVIDUAL INSTALLATION FUNCTIONS
# =============================================================================

install_component() {
    local component="$1"
    local script_name="$2"
    local description="$3"

    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}$description${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would execute: bash ${SCRIPTS_DIR}/${script_name}"
        case "$script_name" in
            "01-homebrew.sh")
                echo -e "${BLUE}  → Would install Homebrew and basic CLI tools (git, wget, curl, tree, jq)${NC}"
                ;;
            "02-zsh.sh")
                echo -e "${BLUE}  → Would install Oh My Zsh, Powerlevel10k and plugins${NC}"
                ;;
            "03-languages.sh")
                echo -e "${BLUE}  → Would install Node.js (nvm), Python (pyenv), Go${NC}"
                ;;
            "04-apps.sh")
                echo -e "${BLUE}  → Would install VSCode, Cursor, Claude Code, Bruno, AppCleaner, Boring Notch${NC}"
                echo -e "${BLUE}  → Would install Nerd Fonts and modern CLI tools${NC}"
                ;;
            "05-macos.sh")
                echo -e "${BLUE}  → Would configure system preferences (Dock, Finder, Trackpad, etc.)${NC}"
                ;;
            "06-dotfiles.sh")
                echo -e "${BLUE}  → Would copy configuration files (.zshrc, .gitconfig, etc.)${NC}"
                ;;
        esac
    else
        bash "${SCRIPTS_DIR}/${script_name}"
    fi
}

# =============================================================================
# INSTALLATION MODES
# =============================================================================

# Sequential installation with all components
sequential_install() {
    if ! confirm "Do you want to continue with the full installation?"; then
        print_warning "Installation cancelled"
        exit 0
    fi

    # Run all scripts in sequence
    run_script "${SCRIPTS_DIR}/01-homebrew.sh" "Homebrew Installation"
    run_script "${SCRIPTS_DIR}/02-zsh.sh" "Zsh Configuration"
    run_script "${SCRIPTS_DIR}/03-languages.sh" "Programming Languages Installation"
    run_script "${SCRIPTS_DIR}/04-apps.sh" "Applications Installation"
    run_script "${SCRIPTS_DIR}/05-macos.sh" "macOS Settings"
    run_script "${SCRIPTS_DIR}/06-dotfiles.sh" "Dotfiles Configuration"
}

# Interactive menu installation
menu_install() {
    echo -e "${BOLD}Select which components you want to install:${NC}\n"
    echo -e "  ${GREEN}1)${NC} Install ALL (complete installation)"
    echo -e "  ${BLUE}2)${NC} Homebrew and basic tools"
    echo -e "  ${BLUE}3)${NC} Zsh and Powerlevel10k"
    echo -e "  ${BLUE}4)${NC} Programming languages (Node, Python, Go)"
    echo -e "  ${BLUE}5)${NC} Applications and fonts"
    echo -e "  ${BLUE}6)${NC} macOS configuration"
    echo -e "  ${BLUE}7)${NC} Dotfiles"
    echo -e "  ${YELLOW}8)${NC} Custom installation (multiple selection)"
    echo -e "  ${RED}0)${NC} Exit\n"

    echo -e -n "${CYAN}Select an option [0-8]: ${NC}"
    read -r choice

    case $choice in
        1)
            if confirm "Install ALL components?"; then
                install_component "homebrew" "01-homebrew.sh" "Installing Homebrew..."
                install_component "zsh" "02-zsh.sh" "Configuring Zsh..."
                install_component "languages" "03-languages.sh" "Installing programming languages..."
                install_component "apps" "04-apps.sh" "Installing applications..."
                install_component "macos" "05-macos.sh" "Configuring macOS..."
                install_component "dotfiles" "06-dotfiles.sh" "Installing dotfiles..."
            else
                print_warning "Installation cancelled"
                exit 0
            fi
            ;;
        2) install_component "homebrew" "01-homebrew.sh" "Installing Homebrew..." ;;
        3) install_component "zsh" "02-zsh.sh" "Configuring Zsh..." ;;
        4) install_component "languages" "03-languages.sh" "Installing programming languages..." ;;
        5) install_component "apps" "04-apps.sh" "Installing applications..." ;;
        6) install_component "macos" "05-macos.sh" "Configuring macOS..." ;;
        7) install_component "dotfiles" "06-dotfiles.sh" "Installing dotfiles..." ;;
        8) custom_install ;;
        0)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option"
            exit 1
            ;;
    esac
}

# Custom installation with multiple selection
custom_install() {
    local selections=()

    echo -e "\n${BOLD}Select the components to install (space-separated):${NC}\n"
    echo -e "  ${BLUE}1)${NC} Homebrew and basic tools"
    echo -e "  ${BLUE}2)${NC} Zsh and Powerlevel10k"
    echo -e "  ${BLUE}3)${NC} Programming languages"
    echo -e "  ${BLUE}4)${NC} Applications and fonts"
    echo -e "  ${BLUE}5)${NC} macOS configuration"
    echo -e "  ${BLUE}6)${NC} Dotfiles\n"

    echo -e -n "${YELLOW}Enter your selections (e.g., 1 2 4): ${NC}"
    read -r input

    # Convert input to array
    IFS=' ' read -ra selections <<< "$input"

    # Execute selected installations
    for selection in "${selections[@]}"; do
        case $selection in
            1) install_component "homebrew" "01-homebrew.sh" "Installing Homebrew..." ;;
            2) install_component "zsh" "02-zsh.sh" "Configuring Zsh..." ;;
            3) install_component "languages" "03-languages.sh" "Installing programming languages..." ;;
            4) install_component "apps" "04-apps.sh" "Installing applications..." ;;
            5) install_component "macos" "05-macos.sh" "Configuring macOS..." ;;
            6) install_component "dotfiles" "06-dotfiles.sh" "Installing dotfiles..." ;;
            *) echo -e "${RED}Invalid option: $selection${NC}" ;;
        esac
    done
}

# =============================================================================
# MAIN PROGRAM
# =============================================================================

main() {
    show_banner

    # Check that we're on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script only works on macOS"
        exit 1
    fi

    # Detect architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        print_info "Detected: Apple Silicon (M1/M2/M3)"
        BREW_PREFIX="/opt/homebrew"
    else
        print_info "Detected: Intel Mac"
        BREW_PREFIX="/usr/local"
    fi

    # Initialize log
    echo "=== Setup started: $(date) ===" > "$LOG_FILE"
    echo "Architecture: $ARCH" >> "$LOG_FILE"

    # Show what will be installed
    print_info "This process will install and configure:"
    echo "  1. Homebrew"
    echo "  2. Zsh + Oh My Zsh"
    echo "  3. Node.js (nvm) and Python (pyenv)"
    echo "  4. Applications (VSCode, Cursor, OrbStack, Bruno, AppCleaner, etc.)"
    echo "  5. macOS settings"
    echo "  6. Dotfiles"

    # Select installation mode
    echo -e "\n${BOLD}Select installation mode:${NC}"
    echo -e "  ${GREEN}1)${NC} Sequential mode with confirmations (default)"
    echo -e "  ${BLUE}2)${NC} Interactive menu mode (custom selection)"
    echo -e -n "${CYAN}Select an option [1-2]: ${NC}"
    read -r mode_choice

    case ${mode_choice:-1} in
        2)
            print_info "Starting interactive menu mode..."
            menu_install
            ;;
        1|*)
            print_info "Continuing in sequential mode..."
            sequential_install
            ;;
    esac

    # Show completion message
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}✓ Installation completed successfully${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    print_success "Your Mac has been successfully configured!"
    print_info "Log saved at: $LOG_FILE"

    echo -e "\n${YELLOW}NEXT STEPS:${NC}"
    echo "  1. Restart your terminal to apply all changes"
    echo "  2. Configure Git with your credentials:"
    echo "     git config --global user.name \"Your Name\""
    echo "     git config --global user.email \"your@email.com\""
    echo "  3. Consider creating a dotfiles repository to backup your configuration"
    echo ""

    if confirm "Do you want to restart the terminal now?"; then
        print_info "Restarting terminal..."
        exec $SHELL -l
    fi

    print_success "All done! Enjoy your configured Mac."
}

# Execute main program
main
