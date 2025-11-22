# 🧪 Testing Guide - Setup Scripts

This guide will help you test the installation scripts without modifying your system.

## 🔒 Dry-Run Mode (Test Mode)

The **dry-run** mode allows you to execute the scripts without making any changes to the system. It only shows what commands would be executed.

### Using Dry-Run Mode

```bash
./setup.sh --dry-run
# or
./setup.sh --test
# or
./setup.sh -n
```

### What dry-run mode does

- ✅ Shows the ASCII banner
- ✅ Shows the menu options
- ✅ Lists which components would be installed
- ✅ Shows detailed descriptions of each step
- ❌ **DOES NOT execute** any `brew install` commands
- ❌ **DOES NOT modify** system files
- ❌ **DOES NOT install** any applications
- ❌ **DOES NOT change** macOS settings

### Example Output

```
    ███████╗██╗  ██╗███████╗
    ██╔════╝██║  ██║╚══███╔╝
    ███████╗███████║  ███╔╝
    ╚════██║██╔══██║ ███╔╝
    ███████║██║  ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚══════╝

macOS Development Environment Setup
🧪 TEST MODE (DRY RUN)
No changes will be made to the system
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Select which components you want to install:

  1) Install ALL (complete installation)
  2) Homebrew and basic tools
  3) Zsh and Powerlevel10k
  ...

[DRY RUN] Would execute: bash /path/to/01-homebrew.sh
  → Would install Homebrew and basic CLI tools (git, wget, curl, tree, jq)
```

## 🖥 Other Testing Options

### 1. Virtual Machine (Recommended for full testing)

If you want to test the complete script with real installations:

#### UTM (Free, for Apple Silicon and Intel)

```bash
# 1. Install UTM
brew install --cask utm

# 2. Download macOS from UTM Gallery
# https://mac.getutm.app/gallery/

# 3. Create VM and run the script
```

#### Parallels Desktop (Paid, faster)

```bash
# 1. Install Parallels
# https://www.parallels.com/

# 2. Create macOS VM
# 3. Run the script in the VM
```

### 2. Docker Container (Limited)

⚠️ **Note**: Docker cannot run macOS, only works for testing generic bash scripts.

```bash
# NOT recommended for this specific case
# These scripts are designed for macOS
```

### 3. Manual Code Review

You can review what each script would do:

```bash
# See what Homebrew would install
cat scripts/01-homebrew.sh

# See applications that would be installed
grep -A 20 "APPS=(" scripts/04-apps.sh

# See fonts that would be installed
grep -A 10 "FONTS=(" scripts/04-apps.sh
```

## 📊 Method Comparison

| Method | Safety | Realism | Cost | Speed |
|--------|--------|---------|------|-------|
| **Dry-run** | 🟢 100% safe | 🟡 Medium | 🟢 Free | 🟢 Instant |
| **VM (UTM)** | 🟢 Very safe | 🟢 100% real | 🟢 Free | 🟡 Slow |
| **VM (Parallels)** | 🟢 Very safe | 🟢 100% real | 🔴 $99/year | 🟢 Fast |
| **Manual review** | 🟢 100% safe | 🔴 Low | 🟢 Free | 🟡 Medium |

## ✅ Recommendations

### For quick verification (5 minutes)
```bash
./setup.sh --dry-run
```
Then select mode 2 (interactive menu) and option 1 to see the entire simulated installation.

### For complete testing (1-2 hours)
1. Create VM with UTM
2. Install macOS in the VM
3. Clone the repository in the VM
4. Run the script normally

### For detailed review (30 minutes)
Manually review each script to understand what it does:
```bash
# Review in order
cat scripts/01-homebrew.sh
cat scripts/02-zsh.sh
cat scripts/03-languages.sh
cat scripts/04-apps.sh
cat scripts/05-macos.sh
cat scripts/06-dotfiles.sh
```

## 🎯 Useful Test Commands

```bash
# See banner, modes, and menu (without executing anything)
./setup.sh --dry-run

# See what applications would be installed
grep -E "(APPS|FONTS|CLI_EXTRAS)=\(" scripts/04-apps.sh -A 15

# See what macOS settings would be applied
grep "defaults write" scripts/05-macos.sh

# Count how many applications would be installed
grep -E '".*".*#' scripts/04-apps.sh | wc -l
```

## 🔍 Security Verification

Before running any script on your real system:

```bash
# 1. Check for destructive commands
grep -r "rm -rf" scripts/
grep -r "sudo rm" scripts/

# 2. Verify it doesn't modify critical system files
grep -r "/System/" scripts/
grep -r "/Library/System" scripts/

# 3. Review that it uses confirmations
grep -r "confirm" scripts/
```

## 📝 Important Notes

1. **Always use dry-run first** before running on your real system
2. **The scripts are safe** - they only install software and configure preferences
3. **Dry-run mode is 100% safe** - it doesn't modify absolutely anything
4. **Backups recommended** - Although the scripts are safe, always backup before major changes

## 🆘 Support

If you encounter any problems during testing, review:
- The logs in `setup.log`
- The documentation in `README.md`
- The code of each individual script

---

**Ready to test?**

```bash
# Start here
./setup.sh --dry-run
```
