#!/bin/bash

########################################
# Functions

# Conditionally add `$HOME/.local/bin` to the `PATH` in any given shell rc file
update_shell_rc() {
  local shell_rc=$1
  if [ -f "$shell_rc" ]; then
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$shell_rc"; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"
    fi
  fi
}

########################################
# Insctructions

# Install Kitty
# https://sw.kovidgoyal.net/kitty/binary/#binary-install
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create ~/.local/bin/ if it doesn't exist
if [ ! -d "$HOME/.local/bin" ]; then
  mkdir -p "$HOME/.local/bin"
fi

# Add `~/.local/bin/` to the `PATH` in `~/.bashrc`
update_shell_rc "$HOME/.bashrc"
# Add `~/.local/bin/` to the `PATH` in `~/.zshrc` (if it exists)
update_shell_rc "$HOME/.zshrc"

# Also add `~/.local/bin` to the `PATH` for the current script
# in order to make below `kitty` & `kitten` symlinks immediately available in the current shell
export PATH="$HOME/.local/bin:$PATH"

# Link `kitty` & `kitten` binary to make it available in default bash teminals,
# making them available as global commands
# https://sw.kovidgoyal.net/kitty/binary/#desktop-integration-on-linux
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
