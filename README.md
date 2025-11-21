# Mac Setup Script

Script automatizado para configurar un Mac desde cero. Perfecto para cuando formateas tu computadora o cambias a una nueva Mac.

## Características

- **Modo Semi-automático**: Confirma antes de cambios importantes
- **Modular**: Scripts separados por categoría
- **Completo**: Desde Homebrew hasta dotfiles personalizados
- **Inteligente**: Detecta arquitectura (Apple Silicon/Intel)

## ¿Qué Instala?

### 1. Homebrew
- Package manager para macOS
- Herramientas CLI básicas (git, wget, curl, tree, jq)

### 2. Zsh + Oh My Zsh
- Shell moderno con Oh My Zsh
- Tema Powerlevel10k
- Plugins útiles:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions

### 3. Lenguajes de Programación
- **Node.js**: nvm + versión LTS + pnpm + yarn
- **Python**: pyenv + Python 3.12/3.11 + pipenv + poetry

### 4. Aplicaciones
- Visual Studio Code
- Cursor (AI-powered editor)
- OrbStack (Docker/Linux)
- Nerd Fonts (FiraCode, Hack, Meslo, JetBrains Mono)

### 5. Herramientas CLI Modernas
- `gh` - GitHub CLI
- `fzf` - Fuzzy finder
- `bat` - Cat mejorado
- `eza` - ls moderno
- `ripgrep` - Búsqueda rápida
- `fd` - Find mejorado
- `tldr` - Documentación simplificada
- `htop` - Monitor de sistema

### 6. Configuraciones de macOS
- **Teclado**: Velocidad máxima, sin corrección automática
- **Trackpad**: Tap to click, velocidad máxima
- **Dock**: Auto-hide, animaciones rápidas
- **Finder**: Mostrar extensiones, archivos ocultos, path bar
- **Screenshots**: Carpeta organizada, formato PNG

### 7. Dotfiles
- `.zshrc` completo con aliases y funciones
- `.gitconfig` con aliases y configuración optimizada
- SSH config básico
- Estructura de directorios (~/Developer, ~/Projects)

## Uso Rápido

```bash
cd mac-setup
./setup.sh
```

## Instalación Detallada

### 1. Clonar/Descargar

```bash
# Si tienes este código localmente
cd mac-setup
```

### 2. Hacer Ejecutable (si es necesario)

```bash
chmod +x setup.sh
chmod +x scripts/*.sh
```

### 3. Ejecutar

```bash
./setup.sh
```

El script te preguntará antes de cada sección:
- Homebrew
- Zsh
- Lenguajes (Node.js, Python)
- Aplicaciones
- Configuraciones macOS
- Dotfiles

## Scripts Individuales

También puedes ejecutar scripts individuales:

```bash
# Solo instalar Homebrew
./scripts/01-homebrew.sh

# Solo configurar Zsh
./scripts/02-zsh.sh

# Solo instalar lenguajes
./scripts/03-languages.sh

# Solo instalar aplicaciones
./scripts/04-apps.sh

# Solo configurar macOS
./scripts/05-macos.sh

# Solo copiar dotfiles
./scripts/06-dotfiles.sh
```

## Estructura del Proyecto

```
mac-setup/
├── README.md           # Este archivo
├── setup.sh            # Script principal
├── scripts/            # Scripts modulares
│   ├── 01-homebrew.sh
│   ├── 02-zsh.sh
│   ├── 03-languages.sh
│   ├── 04-apps.sh
│   ├── 05-macos.sh
│   └── 06-dotfiles.sh
└── dotfiles/           # Archivos de configuración
    ├── .zshrc
    └── .gitconfig
```

## Personalización

### Modificar Aplicaciones

Edita `scripts/04-apps.sh` y agrega/quita aplicaciones del array:

```bash
APPS=(
    "visual-studio-code"
    "cursor"
    "orbstack"
    # "google-chrome"      # Agregar Chrome
    # "slack"              # Agregar Slack
)
```

### Modificar Herramientas CLI

Edita `scripts/01-homebrew.sh` o `scripts/04-apps.sh`:

```bash
CLI_TOOLS=(
    "git"
    "wget"
    # "neovim"    # Agregar Neovim
)
```

### Modificar Configuraciones macOS

Edita `scripts/05-macos.sh` para ajustar configuraciones del sistema.

### Personalizar Dotfiles

Los dotfiles están en `dotfiles/`:
- Edita `.zshrc` para agregar aliases, funciones, etc.
- Edita `.gitconfig` para cambiar aliases de git

## Después de la Instalación

### 1. Configurar Git

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### 2. Configurar Powerlevel10k (Tema de Terminal)

```bash
p10k configure
```

### 3. Generar SSH Key

```bash
ssh-keygen -t ed25519 -C "tu@email.com"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

# Copiar clave pública
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Luego agrega la clave a GitHub/GitLab.

### 4. Cambiar Fuente de Terminal

1. Abre Terminal/iTerm2
2. Ve a Preferencias → Profiles → Text
3. Cambia la fuente a cualquier Nerd Font (ej: "MesloLGS Nerd Font")

### 5. Reiniciar Terminal

```bash
exec $SHELL -l
```

O simplemente cierra y abre tu terminal.

## Respaldar Dotfiles en GitHub

### Crear Repositorio

```bash
cd mac-setup
git init
git add .
git commit -m "Initial dotfiles setup"
git remote add origin git@github.com:TU_USUARIO/dotfiles.git
git push -u origin main
```

### Usar en Nueva Mac

```bash
# Clonar repo
git clone git@github.com:TU_USUARIO/dotfiles.git
cd dotfiles

# Ejecutar setup
./setup.sh
```

## Aliases Útiles (Incluidos en .zshrc)

### Git
- `gs` - git status
- `ga` - git add
- `gc` - git commit -m
- `gp` - git push
- `gl` - git pull
- `glog` - git log bonito

### Node.js
- `ni` - npm install
- `nrd` - npm run dev
- `nrs` - npm run start
- `nrb` - npm run build

### Docker
- `dps` - docker ps
- `dc` - docker-compose
- `dcu` - docker-compose up

### Sistema
- `update` - Actualizar Homebrew y paquetes
- `cleanup` - Limpiar caches
- `ll` - ls mejorado (con eza/exa)

Ver todos los aliases: `alias`

## Funciones Útiles (Incluidas en .zshrc)

- `mkcd <dir>` - Crear directorio y entrar
- `extract <file>` - Extraer cualquier archivo comprimido
- `gcl <url>` - Git clone y cd al directorio
- `killport <puerto>` - Matar proceso en puerto
- `serve [puerto]` - Servidor HTTP rápido

## Troubleshooting

### Homebrew no se encuentra

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

### NVM no funciona

```bash
source ~/.zshrc
```

### Cambios de macOS no aplican

1. Cerrar sesión y volver a entrar
2. O reiniciar el sistema

### Oh My Zsh no carga

```bash
source $ZSH/oh-my-zsh.sh
```

## Requisitos

- macOS (probado en macOS 12+)
- Conexión a Internet
- Permisos de administrador

## Notas Importantes

1. **Backup**: El script hace backup de dotfiles existentes antes de sobrescribir
2. **Seguro**: Modo semi-automático te permite controlar qué se instala
3. **Idempotente**: Puedes ejecutarlo múltiples veces sin problemas
4. **Logs**: Todos los logs se guardan en `setup.log`

## Personalización Adicional

### Agregar más dotfiles

1. Agrega archivos a `dotfiles/`
2. Modifica `scripts/06-dotfiles.sh` para copiarlos

### Agregar comandos post-instalación

Edita `setup.sh` al final para agregar pasos adicionales.

## Contribuir

Siéntete libre de personalizar este script para tus necesidades. Algunas ideas:

- Agregar más aplicaciones
- Agregar más configuraciones de macOS
- Agregar scripts de VSCode/Cursor
- Agregar configuración de SSH/GPG más avanzada

## Recursos

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [NVM](https://github.com/nvm-sh/nvm)
- [Pyenv](https://github.com/pyenv/pyenv)

## Licencia

Libre para usar, modificar y distribuir.

---

¡Disfruta tu Mac configurado! 🚀
