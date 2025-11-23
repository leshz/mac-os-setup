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
    github

    # Node.js / JavaScript
    node
    npm
    yarn

    # Python
    python
    pip

    # Docker / Contenedores
    docker
    docker-compose

    # Autocompletado y sugerencias
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions

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
)

# Cargar Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# USER CONFIGURATION
# =============================================================================

# Preferred editor
# Si Neovim está instalado, usarlo como editor por defecto
if command -v nvim &> /dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='nano'
  export VISUAL='code'
fi

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
# NVM (NODE VERSION MANAGER)
# =============================================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Cargar nvm automáticamente
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# =============================================================================
# PYENV (PYTHON VERSION MANAGER)
# =============================================================================

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

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

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --decorate --graph"
alias gundo="git reset --soft HEAD~1"

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

# Docker
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias dstop="docker stop"
alias drm="docker rm"
alias drmi="docker rmi"
alias dprune="docker system prune -a"

# Docker Compose
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcd="docker-compose down"
alias dcr="docker-compose restart"
alias dcl="docker-compose logs -f"

# OrbStack (si está instalado)
alias orb="orbstack"

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

# Quick edits
alias hosts="sudo $EDITOR /etc/hosts"

# Neovim aliases
if command -v nvim &> /dev/null; then
  alias vim="nvim"
  alias vi="nvim"
  alias v="nvim"
fi

# =============================================================================
# FUNCTIONS
# =============================================================================

# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && cd "$_";
}

# Extract various archive formats
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git clone and cd into directory
gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick web search from terminal
google() {
    open "https://www.google.com/search?q=$*"
}

# Create a backup of a file
backup() {
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Find and kill process by name
killport() {
    lsof -ti:$1 | xargs kill -9
}

# Quick server
serve() {
    local port="${1:-8000}"
    open "http://localhost:${port}/" && python -m http.server "$port"
}

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
# WELCOME MESSAGE
# =============================================================================

echo "🚀 Zsh loaded successfully!"
echo ""
echo "Quick tips:"
echo "  • Type 'alias' to see all available shortcuts"
echo "  • Use 'z <directory>' for smart navigation with zoxide"
echo "  • Use 'lg' to open lazygit in a git repository"
echo "  • Press ↑ to search history with atuin (if installed)"
echo ""

# =============================================================================
# LOCAL CUSTOMIZATIONS
# =============================================================================

# Source local zshrc if exists (for machine-specific configs)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
