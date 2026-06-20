# =============================================================================
# ZSHRC CONFIGURATION
# Configuración personalizada de Zsh con Oh My Zsh
# =============================================================================

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# =============================================================================
# THEME
# =============================================================================

# Desactivar tema de Oh My Zsh (usaremos Starship)
ZSH_THEME=""

# =============================================================================
# OH MY ZSH PLUGINS
# =============================================================================

plugins=(
    # Git
    git

    # Python
    python
    pip

    # Docker / Contenedores
    docker
    docker-compose

    # Autocompletado y sugerencias
    zsh-autosuggestions
    zsh-completions
    zsh-interactive-cd

    # Herramientas
    fzf
    brew
    macos
    vscode

    # Otras utilidades
    colored-man-pages
    command-not-found
    copypath
    copyfile
    web-search

    # zsh-syntax-highlighting DEBE ser el último plugin del array,
    # de lo contrario pierde el resaltado de widgets ZLE
    zsh-syntax-highlighting
)

# Usar dump cacheado de compinit (sin compaudit en cada arranque)
ZSH_DISABLE_COMPFIX=true

# Cargar Oh My Zsh
source $ZSH/oh-my-zsh.sh

ZSH_TMUX_ITERM2=true

# =============================================================================
# USER CONFIGURATION
# =============================================================================

# Preferred editor — interactive picker (nvim / code / leaf) via fzf
export EDITOR="$HOME/.local/bin/pick-editor"
export VISUAL="$HOME/.local/bin/pick-editor"

# =============================================================================
# HOMEBREW
# =============================================================================

# Homebrew (detectar arquitectura)
if [[ $(uname -m) == "arm64" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

# =============================================================================
# FNM (NODE VERSION MANAGER — Rust, fast)
# =============================================================================

if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# =============================================================================
# PYENV (PYTHON VERSION MANAGER — lazy load)
# =============================================================================

# `pyenv init` cuesta ~350ms en cada arranque. En vez de eager, se inicializa
# on-demand: la primera vez que se invoca pyenv/python/python3 se carga el init
# real (una sola vez por sesión, ~220ms), y el shim se elimina.
# NOTA: `pip` se omite a propósito de los shims — más abajo hay `alias pip=pip3`
# y zsh no permite definir una función con el nombre de un alias existente.
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &> /dev/null || [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"

  _pyenv_lazy_init() {
    unset -f pyenv python python3 2>/dev/null
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
  }
  pyenv()   { _pyenv_lazy_init; pyenv "$@"; }
  python()  { _pyenv_lazy_init; python "$@"; }
  python3() { _pyenv_lazy_init; python3 "$@"; }
fi

# =============================================================================
# FZF (FUZZY FINDER)
# =============================================================================

# Auto-completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF configuration
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Use fd instead of find
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# =============================================================================
# ZOXIDE (Smart CD)
# =============================================================================

# Inicializar zoxide si está instalado
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# =============================================================================
# ATUIN (Shell History)
# =============================================================================

# Inicializar atuin si está instalado
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# =============================================================================
# STARSHIP PROMPT
# =============================================================================

# Inicializar Starship prompt si está instalado
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# =============================================================================
# ALIASES
# =============================================================================

# General
alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"


alias c="clear -x"
alias dev="npm run dev"
alias npmv="npm --no-git-tag-version version"
# Edit host server - reload 
alias ehs="sudo nvim /etc/hosts"
alias ehr="sudo killall -HUP mDNSResponder"
# Clear install npm
alias cin="rm -rf node_modules package-lock.json && npm cache clean --force && npm install"
alias update="brew update && brew upgrade && brew cleanup"
alias m="music"
alias x="exit"

# List files
if command -v eza &> /dev/null; then
  # Usar eza si está instalado (moderno ls)
  alias ls="eza --icons"
  alias ll="eza -l --icons --git"
  alias la="eza -la --icons --git"
  alias lt="eza --tree --level=2 --icons"
else
  # Fallback a ls normal
  alias ll="ls -lh"
  alias la="ls -lAh"
fi

# Cat con syntax highlighting
if command -v bat &> /dev/null; then
  alias cat="bat"
fi

# Lazygit
if command -v lazygit &> /dev/null; then
  alias lg="lazygit"
fi

# Node.js / npm
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nis="npm install --save"
alias nrd="npm run dev"
alias nrs="npm run start"
alias nrb="npm run build"
alias nrt="npm run test"

# Python
alias py="python"
alias py3="python3"
alias pip="pip3"
alias venv="python -m venv"
alias activate="source venv/bin/activate"

# System
alias update="brew update && brew upgrade && brew cleanup"
alias cleanup="brew cleanup && npm cache clean --force && pip cache purge"

# Network
alias localip="ipconfig getifaddr en0"
alias publicip="curl ifconfig.me"

# Utilities
alias weather="curl wttr.in"
alias ports="netstat -tulanp"
alias path='echo $PATH | tr ":" "\n"'

# Neovim aliases
if command -v nvim &> /dev/null; then
  alias vim="nvim"
  alias vi="nvim"
  alias v="nvim"
fi

# Claude Code CLI
alias cad='claude --allow-dangerously-skip-permissions'

# =============================================================================
# FUNCTIONS
# =============================================================================


# =============================================================================
# PATH ADDITIONS
# =============================================================================

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add custom scripts
export PATH="$HOME/bin:$PATH"

# =============================================================================
# CUSTOM SETTINGS
# =============================================================================

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Don't record duplicate commands
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Share history between terminals
setopt SHARE_HISTORY

# Better directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Correct typos
setopt CORRECT
setopt CORRECT_ALL

# =============================================================================
# LOCAL CUSTOMIZATIONS
# =============================================================================

export HOMEBREW_NO_ENV_HINTS=1

# Source local zshrc if exists (for machine-specific configs)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
