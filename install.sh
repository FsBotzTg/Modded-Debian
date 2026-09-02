#!/bin/bash
# ============================================================
#   Modded-Debian Installer for Termux
#   Made by Firos Sha Muhammad
#   github.com/FsBotzTg/Modded-Debian
# ============================================================

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m'
BOLD='\033[1m'

# proot-distro's command is "proot-distro" — wrap it as "pd" so the
# rest of this script (and your muscle memory) keeps working even
# on a fresh Termux install that hasn't aliased it yet.
pd() { proot-distro "$@"; }

banner() {
clear
echo -e "${CYAN}${BOLD}"
cat << "EOF"
  __  __           _     _          _   ____       _     _
 |  \/  | ___   __| | __| | ___  __| | |  _ \ ___| |__ (_) __ _ _ __
 | |\/| |/ _ \ / _\`|/ _\`|/ _ \/ _\`| | | | |/ _ \ '_ \| |/ _\`| '_ \
 | |  | | (_) | (_| | (_| |  __/ (_| | | |_| |  __/ |_) | | (_| | | | |
 |_|  |_|\___/ \__,_|\__,_|\___|\__,_| |____/ \___|_.__/|_|\__,_|_| |_|
EOF
echo -e "${NC}"
echo -e "${YELLOW}${BOLD}              Modded Debian for Termux${NC}"
echo -e "${MAGENTA}              Made by Firos Sha Muhammad${NC}"
echo -e "${CYAN}              github.com/FsBotzTg/Modded-Debian${NC}"
echo ""
echo -e "${GREEN}------------------------------------------------------------${NC}"
echo ""
}

step() { echo -e "${CYAN}${BOLD}[*]${NC} $1"; }
ok()   { echo -e "${GREEN}${BOLD}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}${BOLD}[!]${NC} $1"; }

banner
warn "Before continuing, make sure you've installed the Termux:X11 APK."
warn "(https://github.com/termux/termux-x11/releases)"
echo ""
read -rp "Press Enter to start the installation..." _

step "Updating Termux package lists..."
pkg update -y

step "Upgrading installed packages..."
yes | pkg upgrade

step "Installing x11-repo (needed to see the X11 GUI packages)..."
yes | pkg install x11-repo

step "Refreshing package lists to pick up the new repo..."
pkg update -y

step "Installing proot-distro, pulseaudio, termux-x11, wget, git, python..."
yes | pkg install proot-distro pulseaudio termux-x11-nightly wget git python

step "Downloading Modded-Debian rootfs..."
wget -q --show-progress https://github.com/FsBotzTg/Modded-Debian/releases/download/modded_debian/debian.tar.gz

banner
step "Restoring Debian rootfs into proot-distro..."
pd restore debian.tar.gz
pd rename debian2 debian
rm debian.tar.gz
ok "Debian rootfs installed."

step "Downloading the GUI launcher..."
wget -q --show-progress https://github.com/FsBotzTg/Modded-Debian/releases/download/modded_debian/debian
mv debian "$PREFIX/bin/"
chmod +x "$PREFIX/bin/debian"
ok "GUI launcher installed."

step "Creating the terminal launcher..."
cat > "$PREFIX/bin/debiant" << 'INNER'
#!/bin/bash
proot-distro login debian
INNER
chmod +x "$PREFIX/bin/debiant"
ok "Terminal launcher installed."

echo ""
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD}   Modded-Debian installed successfully!${NC}"
echo -e "${GREEN}${BOLD}============================================================${NC}"
echo ""
echo -e "${YELLOW}${BOLD}How to use it:${NC}"
echo -e "  ${CYAN}${BOLD}debian${NC}   -> launches the ${BOLD}GUI${NC} version (Make shure to install Termux:X11 app first)"
echo -e "  ${CYAN}${BOLD}debiant${NC}  -> launches the ${BOLD}terminal-only${NC} version"
echo ""
echo -e "${MAGENTA}Credits: Modded-Debian by Firos Sha Muhammad (FsBotzTg)${NC}"
echo -e "${MAGENTA}github.com/FsBotzTg/Modded-Debian${NC}"
echo ""
