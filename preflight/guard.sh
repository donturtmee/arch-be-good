#!/bin/bash

abort() {
  echo -e "\e[31m>>> arch-be-good requires: $1\e[0m"
  read -rp "Proceed anyway? [y/N] " a
  [[ $a == [yY] ]] || exit 1
}

# Enforce upstream/vanilla Arch Linux
[[ -f /etc/arch-release ]] || abort "Arch Linux"
for marker in /etc/cachyos-release /etc/eos-release /etc/garuda-release /etc/manjaro-release; do
  [[ -f $marker ]] && abort "Vanilla Arch (derivative detected)"
done

# Prevent root execution to safeguard user-space configuration
((EUID != 0)) || abort "Run as normal user (not root)"

# Architecture validation
[[ $(uname -m) == "x86_64" ]] || abort "x86_64 CPU"

# Ensure Secure Boot is disabled to prevent bootloader/kernel hook failures
if bootctl status 2>/dev/null | grep -q 'Secure Boot: enabled'; then
  abort "Secure boot disabled"
fi

# Prevent conflicts by ensuring no DE is pre-installed
if pacman -Qe gnome-shell &>/dev/null || pacman -Qe plasma-desktop &>/dev/null; then
  abort "a fresh system (GNOME/KDE detected)"
fi

# Active internet
ping -c1 -W3 archlinux.org &>/dev/null || abort "a working network connection"

echo "Guards: OK"
