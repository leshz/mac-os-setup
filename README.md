# Mac Setup Script

```
███████╗██╗  ██╗███████╗
██╔════╝██║  ██║╚══███╔╝
███████╗███████║  ███╔╝
╚════██║██╔══██║ ███╔╝
███████║██║  ██║███████╗
╚══════╝╚═╝  ╚═╝╚══════╝
```

Automated script to set up a Mac from scratch. Perfect for when you format your computer or switch to a new Mac.

## Quick Start

```bash
# Clone or download this repo
cd mac-setup

# Option 1: Using Make (Recommended)
make install

# Option 2: Direct script execution
./setup.sh
```

## Features

- **Two Installation Modes**:
  - Sequential mode with confirmations for each step
  - Interactive menu mode for selective installation
- **Modular**: Separate scripts by category
- **Complete**: From Homebrew to custom dotfiles
- **Smart**: Detects architecture (Apple Silicon/Intel)
- **Beautiful**: ASCII art banner and colored output
- **Make Support**: Professional Makefile for easy management

## What Does It Install?

### 1. Homebrew
- Package manager for macOS
- Basic CLI tools (git, wget, curl, tree, jq)

### 2. Zsh + Oh My Zsh + Starship
- Modern shell with Oh My Zsh
- **Starship prompt** - Fast, customizable, cross-shell prompt written in Rust
- Useful plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions

### 3. Programming Languages
- **Node.js**: nvm + LTS version + pnpm + yarn
- **Python**: pyenv + Python 3.12/3.11 + pipenv + poetry

### 4. Applications
- **Editors**:
  - Visual Studio Code
  - Cursor (AI-powered editor)
  - Claude Code CLI
- **Utilities**:
  - AppCleaner (Complete uninstaller)
  - Boring Notch (Dynamic Island enhancement)
  - Bruno (API client)
- **Containers**:
  - OrbStack (Docker/Linux alternative)
- **Fonts**:
  - Nerd Fonts (FiraCode, Hack, Meslo, JetBrains Mono, Maple Mono)

### 5. Modern CLI Tools
- **Core Tools**:
  - `gh` - GitHub CLI
  - `fzf` - Fuzzy finder
  - `bat` - Enhanced cat with syntax highlighting
  - `eza` - Modern ls replacement
  - `ripgrep` - Fast search tool
  - `fd` - Enhanced find
  - `tldr` - Simplified documentation
  - `htop` - System monitor
- **Productivity**:
  - `zoxide` - Smart cd that learns your habits
  - `atuin` - Enhanced shell history
  - `lazygit` - Terminal UI for git
  - `gping` - Ping with a graph
  - `starship` - Cross-shell prompt
  - `neovim` - Modern vim-based editor
  - `lazyvim` - Pre-configured Neovim IDE distribution

### 6. macOS Configurations
- **Keyboard**: Maximum speed, no autocorrect
- **Trackpad**: Tap to click, maximum speed
- **Dock**: Auto-hide, fast animations
- **Finder**: Show extensions, hidden files, path bar
- **Screenshots**: Organized folder, PNG format

### 7. Dotfiles
- Complete `.zshrc` with aliases and functions
- `.gitconfig` with aliases and optimized configuration
- `.gitignore_global` - Global Git ignore patterns
- `starship.toml` - Starship prompt configuration
- **LazyVim** - Pre-configured Neovim distribution with modern IDE features
- Basic SSH config
- Directory structure (~/Developer, ~/Projects, ~/.config)

## Quick Start

### 🧪 Test First (Recommended)

Test the script without making any changes to your system:

```bash
./setup.sh --dry-run
```

This shows exactly what would be installed without actually installing anything.

**For detailed testing guide, see [TESTING.md](TESTING.md)**

### 🚀 Install

Choose between two modes:

#### Option 1: Sequential Mode (Guided)
Goes through each component with confirmations:
```bash
./setup.sh
# Select option 1 to continue in sequential mode
```

#### Option 2: Interactive Menu (Custom)
Select specific components from a menu:
```bash
./setup.sh
# Then select option 2 for interactive menu
```

**Menu options:**
1. Install ALL (complete installation)
2. Homebrew and basic tools
3. Zsh and Starship
4. Programming languages (Node, Python)
5. Applications and fonts
6. macOS configuration
7. Dotfiles
8. Custom installation (multiple selection)

## Detailed Installation

### 1. Clone/Download

```bash
# If you have this code locally
cd setup-script
```

### 2. Make Executable (if needed)

```bash
chmod +x setup.sh
chmod +x scripts/*.sh
```

### 3. Run

```bash
./setup.sh
```

The script will ask you before each section:
- Homebrew
- Zsh
- Languages (Node.js, Python)
- Applications
- macOS Settings
- Dotfiles

## Using Make Commands

The easiest way to manage your setup is using `make`:

### Installation
```bash
make install          # Complete installation
make all              # Same as install
```

### Individual Components
```bash
make homebrew         # Install Homebrew only
make zsh              # Configure Zsh only
make langs            # Install Node.js + Python
make apps             # Install applications + tools
make macos            # Configure macOS settings
make dotfiles         # Copy dotfiles
```

### Verification & Maintenance
```bash
make test             # Check what's installed
make check            # Same as test
make doctor           # Full system diagnosis
make version          # Show installed versions
make update           # Update Homebrew & packages
make clean            # Clean old backups
make backup           # Create manual backup
```

### Dry-Run (Test Before Installing)
```bash
make dry-run              # Simulate full installation
make dry-run-homebrew     # Simulate Homebrew install
make dry-run-zsh          # Simulate Zsh setup
make dry-run-langs        # Simulate languages install
make dry-run-apps         # Simulate apps install
make dry-run-macos        # Simulate macOS config
make dry-run-dotfiles     # Simulate dotfiles setup
```

### Get Help
```bash
make                  # Show all available commands
make help             # Same as above
make list             # List all targets
```

## Individual Scripts

You can also run individual scripts directly:

```bash
# Install Homebrew only
./scripts/01-homebrew.sh

# Configure Zsh only
./scripts/02-zsh.sh

# Install languages only
./scripts/03-languages.sh

# Install applications only
./scripts/04-apps.sh

# Configure macOS only
./scripts/05-macos.sh

# Copy dotfiles only
./scripts/06-dotfiles.sh

# Cleanup/Uninstall everything
./scripts/99-cleanup.sh
```

## Uninstall / Cleanup

Need to remove everything? Use the cleanup script:

```bash
./scripts/99-cleanup.sh
```

The cleanup script offers an interactive menu to selectively remove:

1. **GUI Applications** - VSCode, Cursor, OrbStack, etc.
2. **CLI Tools** - gh, fzf, bat, eza, ripgrep, etc.
3. **Nerd Fonts** - All installed Nerd Fonts
4. **Programming Languages** - Node.js/NVM, Python/Pyenv
5. **Oh My Zsh** - Including all plugins
6. **Dotfiles** - .zshrc, .gitconfig, starship.toml, etc.
7. **macOS Settings** - Restore to system defaults
8. **Homebrew** - Complete Homebrew removal
9. **Everything** - Full cleanup (all of the above)

**Features:**
- ⚠️ Interactive confirmations for safety
- 🗂️ Automatic backup of dotfiles before removal
- 🔍 Selective uninstall - choose what to remove
- ♻️ Cleans up caches and temporary files
- 🔄 Option to restore macOS settings to defaults

**Important Notes:**
- The script will ask for confirmation before each major action
- Backups of dotfiles are preserved
- Some directories (~/Developer, ~/Projects) are not removed
- It's recommended to restart after cleanup

## Project Structure

```
setup-script/
├── README.md              # Main documentation
├── TESTING.md             # Testing guide
├── Makefile               # Make commands for easy management
├── setup.sh               # Main script (both sequential & interactive modes)
├── scripts/               # Modular installation scripts
│   ├── 01-homebrew.sh     # Homebrew installation
│   ├── 02-zsh.sh          # Zsh configuration
│   ├── 03-languages.sh    # Programming languages
│   ├── 04-apps.sh         # Applications and fonts
│   ├── 05-macos.sh        # macOS settings
│   ├── 06-dotfiles.sh     # Dotfiles setup
│   └── 99-cleanup.sh      # Cleanup/Uninstall script
└── dotfiles/              # Configuration files
    ├── .zshrc             # Zsh configuration
    ├── .gitconfig         # Git configuration
    ├── .gitignore_global  # Global Git ignore
    └── starship.toml      # Starship prompt config
```

## Customization

### Modify Applications

Edit `scripts/04-apps.sh` and add/remove applications from the array:

```bash
APPS=(
    "visual-studio-code"
    "cursor"
    "orbstack"
    # "google-chrome"      # Add Chrome
    # "slack"              # Add Slack
)
```

### Modify CLI Tools

Edit `scripts/01-homebrew.sh` or `scripts/04-apps.sh`:

```bash
CLI_TOOLS=(
    "git"
    "wget"
    # "neovim"    # Add Neovim
)
```

### Modify macOS Settings

Edit `scripts/05-macos.sh` to adjust system settings.

### Customize Dotfiles

Dotfiles are in `dotfiles/`:
- Edit `.zshrc` to add aliases, functions, etc.
- Edit `.gitconfig` to change git aliases

## Post-Installation

### 1. Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### 2. Customize Starship Prompt (Optional)

Starship is already configured with a custom theme. To customize further:

```bash
# Edit Starship config
nano ~/.config/starship.toml

# Or use a preset
starship preset nerd-font-symbols -o ~/.config/starship.toml
starship preset pastel-powerline -o ~/.config/starship.toml
```

### 3. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your@email.com"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Then add the key to GitHub/GitLab.

### 4. Change Terminal Font (Required for Icons)

To see icons in Starship prompt and LazyVim, use a Nerd Font:

1. Open Terminal/iTerm2
2. Go to Preferences → Profiles → Text
3. Change font to any Nerd Font installed:
   - MesloLGS Nerd Font (recommended for Starship)
   - FiraCode Nerd Font
   - Hack Nerd Font
   - JetBrains Mono Nerd Font

### 5. Start Neovim with LazyVim

LazyVim is automatically installed during the dotfiles setup. To start using it:

```bash
# First time opening Neovim will install all plugins
nvim

# LazyVim will automatically:
# - Install all plugins
# - Configure LSP servers
# - Set up syntax highlighting
# - Configure keybindings
```

**Useful LazyVim Commands:**
- `<Space>` - Open which-key menu (shows all available commands)
- `:Lazy` - Open plugin manager
- `:Mason` - Install/manage LSP servers, formatters, linters
- `:LazyExtras` - Enable/disable extra features
- `<Space>ff` - Find files
- `<Space>sg` - Search with grep
- `<Space>e` - Toggle file explorer

**Configuration:**
- LazyVim config is in `~/.config/nvim/`
- Customize in `~/.config/nvim/lua/config/`
- Add plugins in `~/.config/nvim/lua/plugins/`

For more info: [LazyVim Documentation](https://www.lazyvim.org/)

### 6. Restart Terminal

```bash
exec $SHELL -l
```

Or simply close and reopen your terminal.

## Backup Dotfiles to GitHub

### Create Repository

```bash
cd setup-script
git init
git add .
git commit -m "feat(macos): initial dotfiles setup"
git remote add origin git@github.com:YOUR_USER/setup-script.git
git push -u origin main
```

### Use on New Mac

```bash
# Clone repo
git clone git@github.com:YOUR_USER/setup-script.git
cd setup-script

# Run setup
./setup.sh
```

## Useful Aliases (Included in .zshrc)

### Git
- `gs` - git status
- `ga` - git add
- `gc` - git commit -m
- `gp` - git push
- `gl` - git pull
- `glog` - pretty git log

### Node.js
- `ni` - npm install
- `nrd` - npm run dev
- `nrs` - npm run start
- `nrb` - npm run build

### Docker
- `dps` - docker ps
- `dc` - docker-compose
- `dcu` - docker-compose up

### System
- `update` - Update Homebrew and packages
- `cleanup` - Clean caches
- `ll` - enhanced ls (with eza/exa)

View all aliases: `alias`

## Useful Functions (Included in .zshrc)

- `mkcd <dir>` - Create directory and cd into it
- `extract <file>` - Extract any compressed file
- `gcl <url>` - Git clone and cd into directory
- `killport <port>` - Kill process on port
- `serve [port]` - Quick HTTP server

## Troubleshooting

### Homebrew not found

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

### NVM not working

```bash
source ~/.zshrc
```

### macOS changes not applying

1. Log out and log back in
2. Or restart the system

### Oh My Zsh not loading

```bash
source $ZSH/oh-my-zsh.sh
```

## 🧪 Testing Mode (Dry-Run)

**Want to see what the script does before installing?**

```bash
./setup.sh --dry-run
```

This **dry-run mode** is completely safe:
- ✅ Shows exactly what would be installed
- ✅ Displays all commands that would run
- ✅ No actual changes to your system
- ✅ Perfect for testing and review

**Aliases**: `--dry-run`, `--test`, or `-n`

For detailed testing guide, see [scripts/TESTING.md](scripts/TESTING.md)

## Requirements

- macOS (tested on macOS 12+)
- Internet connection
- Administrator permissions

## Important Notes

1. **Backup**: The script backs up existing dotfiles before overwriting
2. **Safe**: Semi-automatic mode lets you control what gets installed
3. **Idempotent**: You can run it multiple times without issues
4. **Logs**: All logs are saved in `setup.log`

## Additional Customization

### Add more dotfiles

1. Add files to `dotfiles/`
2. Modify `scripts/06-dotfiles.sh` to copy them

### Add post-installation commands

Edit `setup.sh` at the end to add additional steps.

## Contributing

Feel free to customize this script for your needs. Some ideas:

- Add more applications
- Add more macOS configurations
- Add VSCode/Cursor scripts
- Add more advanced SSH/GPG configuration

## Resources

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Nerd Fonts](https://www.nerdfonts.com/)
- [NVM](https://github.com/nvm-sh/nvm)
- [Pyenv](https://github.com/pyenv/pyenv)
- [Zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd
- [Atuin](https://github.com/atuinsh/atuin) - Enhanced shell history
- [Lazygit](https://github.com/jesseduffield/lazygit) - Terminal UI for git
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [LazyVim](https://www.lazyvim.org/) - Pre-configured Neovim IDE distribution

## License

Free to use, modify, and distribute.

---

Enjoy your configured Mac! 🚀
