# =============================================================================
# MAC SETUP MAKEFILE
# Automatización de instalación y configuración de macOS
# =============================================================================

# Colores para output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Variables
SCRIPTS_DIR := ./scripts
DOTFILES_DIR := ./dotfiles
SETUP_SCRIPT := ./setup.sh

# Default target
.DEFAULT_GOAL := help

# Phony targets (no son archivos)
.PHONY: help install all homebrew zsh langs languages apps tools macos dotfiles \
        test check verify doctor update upgrade clean backup list version dry-run \
        dry-run-homebrew dry-run-zsh dry-run-langs dry-run-apps dry-run-macos dry-run-dotfiles

# =============================================================================
# HELP - Muestra todos los comandos disponibles
# =============================================================================

help:
	@echo ""
	@echo "$(BLUE)╔═══════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║$(NC)  $(GREEN)🚀 MAC SETUP - Sistema de Configuración Automatizada$(NC)     $(BLUE)║$(NC)"
	@echo "$(BLUE)╚═══════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 INSTALACIÓN:$(NC)"
	@echo "  $(GREEN)make install$(NC)      - Instalación completa (recomendado)"
	@echo "  $(GREEN)make all$(NC)          - Alias de 'install'"
	@echo ""
	@echo "$(YELLOW)🔧 COMPONENTES INDIVIDUALES:$(NC)"
	@echo "  $(GREEN)make homebrew$(NC)     - Instalar Homebrew + CLI tools básicas"
	@echo "  $(GREEN)make zsh$(NC)          - Configurar Zsh + Oh My Zsh + plugins"
	@echo "  $(GREEN)make langs$(NC)        - Instalar Node.js (fnm) + Python (pyenv)"
	@echo "  $(GREEN)make apps$(NC)         - Instalar apps (VSCode, Cursor, etc.)"
	@echo "  $(GREEN)make tools$(NC)        - Alias de 'apps' (herramientas CLI)"
	@echo "  $(GREEN)make macos$(NC)        - Configuraciones de macOS"
	@echo "  $(GREEN)make dotfiles$(NC)     - Copiar dotfiles a HOME"
	@echo ""
	@echo "$(YELLOW)✅ VERIFICACIÓN:$(NC)"
	@echo "  $(GREEN)make test$(NC)         - Verificar qué está instalado"
	@echo "  $(GREEN)make check$(NC)        - Alias de 'test'"
	@echo "  $(GREEN)make doctor$(NC)       - Diagnóstico completo del sistema"
	@echo "  $(GREEN)make version$(NC)      - Mostrar versiones instaladas"
	@echo ""
	@echo "$(YELLOW)🔄 MANTENIMIENTO:$(NC)"
	@echo "  $(GREEN)make update$(NC)       - Actualizar Homebrew y paquetes"
	@echo "  $(GREEN)make upgrade$(NC)      - Alias de 'update'"
	@echo "  $(GREEN)make clean$(NC)        - Limpiar backups antiguos (>30 días)"
	@echo "  $(GREEN)make backup$(NC)       - Crear backup de dotfiles actuales"
	@echo ""
	@echo "$(YELLOW)🛠️  UTILIDADES:$(NC)"
	@echo "  $(GREEN)make list$(NC)         - Listar todos los targets disponibles"
	@echo "  $(GREEN)make dry-run$(NC)      - Simulación de instalación completa"
	@echo ""
	@echo "$(YELLOW)🧪 DRY-RUN (Simulación sin cambios):$(NC)"
	@echo "  $(GREEN)make dry-run$(NC)             - Simulación completa"
	@echo "  $(GREEN)make dry-run-homebrew$(NC)    - Solo Homebrew (simulación)"
	@echo "  $(GREEN)make dry-run-zsh$(NC)         - Solo Zsh (simulación)"
	@echo "  $(GREEN)make dry-run-langs$(NC)       - Solo lenguajes (simulación)"
	@echo "  $(GREEN)make dry-run-apps$(NC)        - Solo apps (simulación)"
	@echo "  $(GREEN)make dry-run-macos$(NC)       - Solo macOS (simulación)"
	@echo "  $(GREEN)make dry-run-dotfiles$(NC)    - Solo dotfiles (simulación)"
	@echo ""
	@echo "$(YELLOW)💡 EJEMPLOS:$(NC)"
	@echo "  make install              # Primera instalación completa"
	@echo "  make homebrew apps        # Instalar Homebrew y luego apps"
	@echo "  make dotfiles             # Solo actualizar dotfiles"
	@echo "  make test                 # Ver qué está instalado"
	@echo ""

# =============================================================================
# INSTALACIÓN
# =============================================================================

install: check-shell
	@echo "$(BLUE)🚀 Iniciando instalación completa...$(NC)"
	@bash $(SETUP_SCRIPT)
	@echo "$(GREEN)✅ Instalación completada!$(NC)"

all: install

# =============================================================================
# COMPONENTES INDIVIDUALES
# =============================================================================

homebrew:
	@echo "$(BLUE)📦 Instalando Homebrew...$(NC)"
	@bash $(SCRIPTS_DIR)/01-homebrew.sh
	@echo "$(GREEN)✅ Homebrew instalado!$(NC)"

zsh:
	@echo "$(BLUE)🐚 Configurando Zsh...$(NC)"
	@bash $(SCRIPTS_DIR)/02-zsh.sh
	@echo "$(GREEN)✅ Zsh configurado!$(NC)"

langs: languages

languages:
	@echo "$(BLUE)💻 Instalando lenguajes (Node.js, Python)...$(NC)"
	@bash $(SCRIPTS_DIR)/03-languages.sh
	@echo "$(GREEN)✅ Lenguajes instalados!$(NC)"

apps: tools

tools:
	@echo "$(BLUE)🛠️  Instalando aplicaciones y herramientas...$(NC)"
	@bash $(SCRIPTS_DIR)/04-apps.sh
	@echo "$(GREEN)✅ Aplicaciones instaladas!$(NC)"

macos:
	@echo "$(BLUE)⚙️  Configurando macOS...$(NC)"
	@bash $(SCRIPTS_DIR)/05-macos.sh
	@echo "$(GREEN)✅ macOS configurado!$(NC)"

dotfiles:
	@echo "$(BLUE)📝 Copiando dotfiles...$(NC)"
	@bash $(SCRIPTS_DIR)/06-dotfiles.sh
	@echo "$(GREEN)✅ Dotfiles configurados!$(NC)"

# =============================================================================
# VERIFICACIÓN Y DIAGNÓSTICO
# =============================================================================

test: check

check:
	@echo "$(BLUE)🔍 Verificando instalación...$(NC)"
	@echo ""
	@command -v brew >/dev/null 2>&1 && echo "$(GREEN)✅ Homebrew$(NC)" || echo "$(RED)❌ Homebrew$(NC)"
	@command -v zsh >/dev/null 2>&1 && echo "$(GREEN)✅ Zsh$(NC)" || echo "$(RED)❌ Zsh$(NC)"
	@test -d ~/.oh-my-zsh && echo "$(GREEN)✅ Oh My Zsh$(NC)" || echo "$(RED)❌ Oh My Zsh$(NC)"
	@command -v fnm >/dev/null 2>&1 && echo "$(GREEN)✅ FNM$(NC)" || echo "$(RED)❌ FNM$(NC)"
	@command -v node >/dev/null 2>&1 && echo "$(GREEN)✅ Node.js $$(node --version)$(NC)" || echo "$(RED)❌ Node.js$(NC)"
	@command -v python >/dev/null 2>&1 && echo "$(GREEN)✅ Python $$(python --version | cut -d' ' -f2)$(NC)" || echo "$(RED)❌ Python$(NC)"
	@command -v pyenv >/dev/null 2>&1 && echo "$(GREEN)✅ Pyenv$(NC)" || echo "$(RED)❌ Pyenv$(NC)"
	@command -v code >/dev/null 2>&1 && echo "$(GREEN)✅ VSCode$(NC)" || echo "$(RED)❌ VSCode$(NC)"
	@command -v nvim >/dev/null 2>&1 && echo "$(GREEN)✅ Neovim$(NC)" || echo "$(RED)❌ Neovim$(NC)"
	@command -v starship >/dev/null 2>&1 && echo "$(GREEN)✅ Starship$(NC)" || echo "$(RED)❌ Starship$(NC)"
	@command -v lazygit >/dev/null 2>&1 && echo "$(GREEN)✅ Lazygit$(NC)" || echo "$(RED)❌ Lazygit$(NC)"
	@command -v zoxide >/dev/null 2>&1 && echo "$(GREEN)✅ Zoxide$(NC)" || echo "$(RED)❌ Zoxide$(NC)"
	@command -v atuin >/dev/null 2>&1 && echo "$(GREEN)✅ Atuin$(NC)" || echo "$(RED)❌ Atuin$(NC)"
	@command -v fzf >/dev/null 2>&1 && echo "$(GREEN)✅ FZF$(NC)" || echo "$(RED)❌ FZF$(NC)"
	@command -v bat >/dev/null 2>&1 && echo "$(GREEN)✅ Bat$(NC)" || echo "$(RED)❌ Bat$(NC)"
	@command -v eza >/dev/null 2>&1 && echo "$(GREEN)✅ Eza$(NC)" || echo "$(RED)❌ Eza$(NC)"
	@test -f ~/.zshrc && echo "$(GREEN)✅ .zshrc$(NC)" || echo "$(RED)❌ .zshrc$(NC)"
	@test -f ~/.gitconfig && echo "$(GREEN)✅ .gitconfig$(NC)" || echo "$(RED)❌ .gitconfig$(NC)"
	@test -f ~/.config/starship.toml && echo "$(GREEN)✅ starship.toml$(NC)" || echo "$(RED)❌ starship.toml$(NC)"
	@echo ""

verify: check

doctor:
	@echo "$(BLUE)🏥 Diagnóstico del sistema...$(NC)"
	@echo ""
	@echo "$(YELLOW)Sistema:$(NC)"
	@echo "  OS: $$(uname -s)"
	@echo "  Arquitectura: $$(uname -m)"
	@echo "  Versión: $$(sw_vers -productVersion)"
	@echo ""
	@echo "$(YELLOW)Shell:$(NC)"
	@echo "  Shell actual: $$SHELL"
	@echo "  Zsh version: $$(zsh --version 2>/dev/null || echo 'No instalado')"
	@echo ""
	@echo "$(YELLOW)Homebrew:$(NC)"
	@command -v brew >/dev/null 2>&1 && brew --version || echo "  No instalado"
	@command -v brew >/dev/null 2>&1 && echo "  Prefix: $$(brew --prefix)" || true
	@echo ""
	@echo "$(YELLOW)Herramientas instaladas:$(NC)"
	@$(MAKE) -s check
	@echo ""

version:
	@echo "$(BLUE)📊 Versiones instaladas:$(NC)"
	@echo ""
	@command -v brew >/dev/null 2>&1 && echo "Homebrew: $$(brew --version | head -1)" || echo "Homebrew: No instalado"
	@command -v zsh >/dev/null 2>&1 && echo "Zsh: $$(zsh --version)" || echo "Zsh: No instalado"
	@command -v node >/dev/null 2>&1 && echo "Node.js: $$(node --version)" || echo "Node.js: No instalado"
	@command -v npm >/dev/null 2>&1 && echo "npm: $$(npm --version)" || echo "npm: No instalado"
	@command -v python >/dev/null 2>&1 && echo "Python: $$(python --version)" || echo "Python: No instalado"
	@command -v pip >/dev/null 2>&1 && echo "pip: $$(pip --version | cut -d' ' -f2)" || echo "pip: No instalado"
	@command -v nvim >/dev/null 2>&1 && echo "Neovim: $$(nvim --version | head -1)" || echo "Neovim: No instalado"
	@command -v starship >/dev/null 2>&1 && echo "Starship: $$(starship --version | cut -d' ' -f2)" || echo "Starship: No instalado"
	@command -v git >/dev/null 2>&1 && echo "Git: $$(git --version)" || echo "Git: No instalado"
	@echo ""

# =============================================================================
# MANTENIMIENTO
# =============================================================================

update: upgrade

upgrade:
	@echo "$(BLUE)🔄 Actualizando sistema...$(NC)"
	@command -v brew >/dev/null 2>&1 && brew update && brew upgrade && brew cleanup || echo "$(RED)Homebrew no instalado$(NC)"
	@echo "$(GREEN)✅ Sistema actualizado!$(NC)"

clean:
	@echo "$(BLUE)🧹 Limpiando backups antiguos...$(NC)"
	@find ~ -name "*.backup.*" -mtime +30 -type f 2>/dev/null | while read file; do \
		echo "  Eliminando: $$file"; \
		rm -f "$$file"; \
	done || true
	@echo "$(GREEN)✅ Limpieza completada!$(NC)"

backup:
	@echo "$(BLUE)💾 Creando backup de dotfiles...$(NC)"
	@mkdir -p ~/dotfiles-backup-$$(date +%Y%m%d)
	@test -f ~/.zshrc && cp ~/.zshrc ~/dotfiles-backup-$$(date +%Y%m%d)/ || true
	@test -f ~/.gitconfig && cp ~/.gitconfig ~/dotfiles-backup-$$(date +%Y%m%d)/ || true
	@test -f ~/.config/starship.toml && cp ~/.config/starship.toml ~/dotfiles-backup-$$(date +%Y%m%d)/ || true
	@echo "$(GREEN)✅ Backup creado en ~/dotfiles-backup-$$(date +%Y%m%d)$(NC)"

# =============================================================================
# UTILIDADES
# =============================================================================

list:
	@echo "$(BLUE)📋 Targets disponibles:$(NC)"
	@echo ""
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | \
		awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
		sort | grep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo ""

dry-run:
	@echo "$(YELLOW)⚠️  Dry-run mode (simulación)$(NC)"
	@echo "$(BLUE)Ejecutando setup.sh en modo dry-run...$(NC)"
	@echo ""
	@bash $(SETUP_SCRIPT) --dry-run

dry-run-homebrew:
	@echo "$(YELLOW)⚠️  Dry-run: Instalación de Homebrew$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Verificar si Homebrew está instalado"
	@echo "  • Si no: Instalar Homebrew ($$(uname -m))"
	@echo "  • Actualizar Homebrew"
	@echo "  • Instalar CLI tools: git, wget, curl, tree, jq"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make homebrew"

dry-run-zsh:
	@echo "$(YELLOW)⚠️  Dry-run: Configuración de Zsh$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Instalar Zsh (si no existe)"
	@echo "  • Cambiar shell por defecto a Zsh"
	@echo "  • Instalar Oh My Zsh"
	@echo "  • Instalar plugins: zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions"
	@echo "  • Configurar Starship prompt"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make zsh"

dry-run-langs:
	@echo "$(YELLOW)⚠️  Dry-run: Instalación de lenguajes$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Instalar FNM (Node Version Manager)"
	@echo "  • Instalar Node.js LTS"
	@echo "  • Instalar pnpm y yarn"
	@echo "  • Instalar Pyenv (Python Version Manager)"
	@echo "  • Instalar Python 3.12"
	@echo "  • Instalar pipenv, poetry, virtualenv"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make langs"

dry-run-apps:
	@echo "$(YELLOW)⚠️  Dry-run: Instalación de aplicaciones$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Instalar apps GUI: VSCode, Cursor, OrbStack"
	@echo "  • Instalar Nerd Fonts (4 fuentes)"
	@echo "  • Instalar CLI tools: gh, fzf, bat, eza, ripgrep, fd, tldr, htop"
	@echo "  • Instalar herramientas modernas: zoxide, atuin, lazygit, gping, starship, neovim"
	@echo "  • Configurar fzf"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make apps"

dry-run-macos:
	@echo "$(YELLOW)⚠️  Dry-run: Configuraciones de macOS$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Configurar velocidad de teclado al máximo"
	@echo "  • Deshabilitar corrección automática"
	@echo "  • Configurar trackpad (tap to click, velocidad)"
	@echo "  • Auto-hide del Dock"
	@echo "  • Configurar Finder (extensiones, archivos ocultos)"
	@echo "  • Cambiar ubicación de screenshots"
	@echo "  • Reiniciar Dock, Finder, SystemUIServer"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make macos"

dry-run-dotfiles:
	@echo "$(YELLOW)⚠️  Dry-run: Configuración de dotfiles$(NC)"
	@echo ""
	@echo "$(BLUE)Se ejecutaría:$(NC)"
	@echo "  • Crear backup de dotfiles existentes"
	@echo "  • Copiar .zshrc a ~/."
	@echo "  • Copiar .gitconfig a ~/."
	@echo "  • Copiar .gitignore_global a ~/."
	@echo "  • Copiar starship.toml a ~/.config/"
	@echo "  • Configurar SSH config básico"
	@echo "  • Crear directorios: ~/Developer, ~/Projects, ~/.config"
	@echo ""
	@echo "$(GREEN)Comando real:$(NC) make dotfiles

# =============================================================================
# CHECKS INTERNOS
# =============================================================================

check-shell:
	@if [ ! -x "$(SETUP_SCRIPT)" ]; then \
		echo "$(RED)❌ Error: setup.sh no es ejecutable$(NC)"; \
		echo "Ejecuta: chmod +x $(SETUP_SCRIPT)"; \
		exit 1; \
	fi

# =============================================================================
# INFORMACIÓN
# =============================================================================

.SILENT: help check version list
