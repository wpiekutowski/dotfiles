#!/bin/bash

# This script creates symbolic links for whitelisted dotfiles/directories only.
# Designed for container environments where you only need essential configs.

# Get the absolute path to the directory where this script is located.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

# Source the shared library
source "$DOTFILES_DIR/setup-lib.sh"

echo "Starting container dotfile setup..."
echo "Dotfiles directory: $DOTFILES_DIR"
echo "Home directory:     $HOME_DIR"
echo

# Whitelisted paths relative to DOTFILES_DIR
WHITELIST=(
    ".config/git"
    ".config/nvim"
    ".config/vim"
    ".npmrc"
)

# Process each whitelisted path
for path in "${WHITELIST[@]}"; do
    source_path="$DOTFILES_DIR/$path"

    if [ ! -e "$source_path" ]; then
        echo "WARNING: '$path' does not exist in dotfiles directory. Skipping."
        echo
        continue
    fi

    # If it's a directory, recursively find all files within it
    if [ -d "$source_path" ]; then
        echo "Processing directory '$path'..."
        echo
        find "$source_path" -type f | while read -r file; do
            relative_path="${file#$DOTFILES_DIR/}"
            link_file "$file" "$relative_path"
        done
    # If it's a file, link it directly
    elif [ -f "$source_path" ]; then
        link_file "$source_path" "$path"
    fi
done

# Install git hooks
install_git_hooks

echo "Container dotfile setup complete."
